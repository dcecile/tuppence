require 'source'

Benchmarks =
[
  HtmlSource.new(
    :id => 'overnight',
    :name => 'Target Overnight Lending Rate',
    :human_uri => 'http://bankofcanada.ca/en/rates/digest.html',
    :target => '//td[text() = "Target for the overnight rate"]' +
      '/following-sibling::td[2]'
  ),
  HtmlSource.new(
    :id => 'prime',
    :name => 'Prime Rate',
    :human_uri => 'http://bankofcanada.ca/en/rates/digest.html',
    :target => '//td[text() = "Prime business rate"]' +
      '/following-sibling::td[2]'
  ),
]
