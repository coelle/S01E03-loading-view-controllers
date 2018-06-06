//: To run this playground start a SimpleHTTPServer on the commandline like this:
//:
//: `python -m SimpleHTTPServer 8000`
//:
//: It will serve up the current directory, so make sure to be in the directory containing episode.json

import UIKit

let url = NSURL(string: "http://localhost:8000/episode.json")!
let episodeResource = Resource<Episode>(url: url as URL, parseJSON: { anyObject in
    (anyObject as? JSONDictionary).flatMap(Episode.init)
})
let sampleEpisode = Episode(id: "0", title: "initial")

let sharedWebservice = Webservice()


final class EpisodeDetailViewController: UIViewController {
    let titleLabel = UILabel()
    
    convenience init(episode: Episode) {
        self.init()
        titleLabel.text = episode.title
    }

    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .white
        view.addSubview(titleLabel)
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.constrainEdges(toMarginOf: view)
    }
}


let episodesVC = EpisodeDetailViewController(episode: sampleEpisode)
episodesVC.view.frame = CGRect(x: 0, y: 0, width: 250, height: 300)


import PlaygroundSupport
PlaygroundPage.current.liveView = episodesVC
