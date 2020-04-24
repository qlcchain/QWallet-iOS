import UIKit
import CollectionKit

class MatchInCollectionExampleViewController1: ExampleBaseViewController {
  let collectionView = CollectionView()
  let dataProvider = ArrayDataProvider<Int>(data: Array(0..<30))

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.provider = CollectionProvider(
      dataProvider: dataProvider,
      viewUpdater: { (view: UILabel, data: Int, index: Int) in
        let color = UIColor(hue: CGFloat(data) / 30, saturation: 0.68,
                            brightness: 0.98, alpha: 1)
        view.backgroundColor = color
        view.textColor = .white
        view.textAlignment = .center
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        view.text = "\(data)"
      },
      layout: FlowLayout(spacing: 10).inset(by: UIEdgeInsets(top: 100, left: 10, bottom: 10, right: 10)),
      sizeProvider: { (index, data, collectionSize) in
        let width: CGFloat = (collectionSize.width - 20) / 3
        return CGSize(width: width, height: width)
      },
      tapHandler: { [weak self] (view, index, dataProvider) in
        self?.cellTapped(cell: view, data: dataProvider.data(at: index))
      }
    )
    view.insertSubview(collectionView, belowSubview: dismissButton)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    collectionView.frame = view.bounds
  }

  func cellTapped(cell: UIView, data: Int) {
    // MARK: Hero configuration

    // here we are using the data as the hero.id, we have to make sure that this id is
    // unique for each cell. a random hero.id will also work.
    let heroId = "cell\(data)"
    cell.hero.id = heroId

    let vc = MatchInCollectionExampleViewController2()
    vc.hero.isEnabled = true

    // copy over the backgroundColor and hero.id over to the next view
    // controller. In a real app, we would be passing some data correspoding to the cell
    // being tapped. then configure the next view controller according to the data.
    // and make sure that views that need to be transitioned have the same hero.id

    vc.contentView.backgroundColor = cell.backgroundColor
    vc.contentView.hero.id = heroId

    present(vc, animated: true, completion: nil)
  }
}

class MatchInCollectionExampleViewController2: ExampleBaseViewController {
  let contentView = UIView()

  override func viewDidLoad() {
    super.viewDidLoad()
    contentView.cornerRadius = 8
    view.addSubview(contentView)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    contentView.frame = CGRect(x: (view.bounds.width - 250) / 2, y: 140, width: 250, height: view.bounds.height - 280)
  }
}

