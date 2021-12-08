
import UIKit

class Footer: UIView {

  let label = UILabel()

  weak var tableView: UITableView!
  var observer: Any?

  init(tableView: UITableView) {
    super.init(frame: .zero)

    self.tableView = tableView
    self.backgroundColor = .red
    self.label.text = "footer"
    self.label.textAlignment = .center
    self.addSubview(label)

    tableView.addObserver(self, forKeyPath: "contentSize", options: [.new, .old, .prior], context: nil)

  }

  @objc override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    let o = change?[.oldKey] as? CGSize
    if keyPath == "contentSize", let old = o, tableView.contentSize != old {
        print("contentSize: \(tableView.contentSize)")
        layout()
      }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func layout() {
    let minHeight: CGFloat = 50
    let count = tableView.numberOfRows(inSection: 0)
    let filledHeight = tableView.frame.height - CGFloat(count) * 44.0
    self.frame.size.height = max(minHeight, filledHeight)
    self.tableView.tableFooterView = self

    label.frame = CGRect(x: 0, y: frame.height - 20, width: frame.width, height: 20)
  }
}

class ViewController: UIViewController {

  @IBOutlet
  var tableView: UITableView!

  var footer: Footer!

  var items: [String] = [""]

  override func viewDidLoad() {
    super.viewDidLoad()

    footer = Footer(tableView: tableView)

    tableView.tableFooterView = footer
    tableView.dataSource = self
    tableView.delegate = self

//    tableView.

    tableView.reloadData()
    footer.layout()
  }
}

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    items.count
  }


  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    cell.textLabel?.text = "ITEM - \(indexPath.row)"
    return cell
  }
}

extension ViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row % 2 == 1 {
      items.remove(at: indexPath.row)

      UIView.animate(withDuration: 0.3) {
        self.tableView.deleteRows(at: [indexPath], with: .fade)
      }
    } else {
        items.append("\(indexPath.row)")

      UIView.animate(withDuration: 0.3) {
        self.tableView.insertRows(at: [IndexPath(row: indexPath.row + 1, section: 0)], with: .fade)
      }


    }
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 44
  }
}
