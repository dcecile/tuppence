require 'source'

Benchmarks =
[
  HtmlSource.new(
    'overnight',
    'Target Overnight Lending Rate',
    'http://bankofcanada.ca/en/rates/digest.html',
    nil,
    nil,
    '//td[text() = "Target for the overnight rate"]' +
      '/following-sibling::td[2]'
  ),
  HtmlSource.new(
    'prime',
    'Prime Rate',
    'http://bankofcanada.ca/en/rates/digest.html',
    nil,
    nil,
    '//td[text() = "Prime business rate"]' +
      '/following-sibling::td[2]'
  ),
]
