//: To run this playground start a SimpleHTTPServer on the commandline like this:
//:
//: `python -m SimpleHTTPServer 8000`
//:
//: It will serve up the current directory, so make sure to be in the directory containing episode.json

import UIKit
import PlaygroundSupport

let url = NSURL(string: "http://localhost:8000/episode.json")!
let episodeResource = Resource<Episode>(url: url as URL, parseJSON: { anyObject in
	(anyObject as? JSONDictionary).flatMap(Episode.init)
})
let sampleEpisode = Episode(id: "0", title: "initial")

let sharedWebservice = Webservice()


final class EpisodeDetailViewController: UIViewController {
	let titleLabel = UILabel()
	let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)

	convenience init(episode: Episode) {
		self.init()
		titleLabel.text = episode.title
	}

	convenience init(resource: Resource<Episode>) {
		self.init()
		spinner.startAnimating()
		sharedWebservice.load(resource: resource, completion: {
			[weak self] result in
			self?.spinner.stopAnimating()
			guard let episode = result.value else {
				// Better error handling
				print("No episode found yet")
				return
			}
			self?.titleLabel.text = episode.title
		})
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		spinner.hidesWhenStopped = true
		spinner.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(spinner)
		spinner.center(inView: view)

		view.backgroundColor = .orange
		view.addSubview(titleLabel)
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.constrainEdges(toMarginOf: view)
	}
}


let episodesVC = EpisodeDetailViewController(resource: episodeResource)
episodesVC.view.frame = CGRect(x: 0, y: 0, width: 250, height: 300)


PlaygroundPage.current.liveView = episodesVC
