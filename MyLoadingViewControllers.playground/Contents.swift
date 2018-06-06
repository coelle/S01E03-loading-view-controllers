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

final class LoadingViewController: UIViewController {
	let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)

	init<A>(resource: Resource<A>, build: @escaping (A) -> UIViewController) {
		super.init(nibName: nil, bundle: nil)
		spinner.startAnimating()
		sharedWebservice.load(resource: resource, completion: {
			[weak self] result in
			self?.spinner.stopAnimating()
			guard let value = result.value else {
				// Better error handling
				print("No episode found yet")
				return
			}
			let viewController = build(value)
			self?.add(content: viewController)
		})
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		spinner.hidesWhenStopped = true
		spinner.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(spinner)
		spinner.center(inView: view)
	}

	func add(content: UIViewController) {
		addChildViewController(content)
		view.addSubview(content.view)
		content.view.translatesAutoresizingMaskIntoConstraints = false
		content.view.constrainEdges(toMarginOf: view)
		content.didMove(toParentViewController: self)
	}
}

final class EpisodeDetailViewController: UIViewController {
	let titleLabel = UILabel()

	convenience init(episode: Episode) {
		self.init()
		titleLabel.text = episode.title
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .orange
		view.addSubview(titleLabel)
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.constrainEdges(toMarginOf: view)
	}
}


let episodesVC = LoadingViewController(resource: episodeResource,
									   build: EpisodeDetailViewController.init)
episodesVC.view.frame = CGRect(x: 0, y: 0, width: 250, height: 300)


PlaygroundPage.current.liveView = episodesVC
