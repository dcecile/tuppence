require 'source'

Institutions =
[
  HtmlSource.new(
    'ally',
    'Ally',
    'http://www.ally.ca/en/savings/high-interest-savings-account/compare-hisa-rates.html',
    nil,
    nil,
    '//td' +
      '[@id = "Ally"]' +
      '[//title[contains(text(), "High Interest Savings Account")]]'
  ),
  JavascriptSource.new(
    'bmo',
    'Bank of Montreal',
    'http://www.bmo.com/home/personal/banking/rates/bank-accounts',
    'http://www.bmo.com/bmocda/templates/json_bankacct_include.jsp',
    nil,
    lambda { |doc| doc['OPRS_CA']['99999999.99']['value'] }
  ),
  HtmlSource.new(
    'canadian_tire',
    'Canadian Tire',
    'https://www.myctfs.com/Products/HighIntSavings/',
    'https://www.myctfs.com/Rates/SavingsRates/',
    nil,
    '//td' +
      '[preceding-sibling::th/text() = "High Interest Savings"]'
  ),
  JavascriptSource.new(
    'cibc',
    'CIBC',
    'http://www.cibc.com/ca/chequing-savings/compare-accounts.html?asa',
    'https://www.cibconline.cibc.com/olbtxn/rds?lobId=3&sourceProductCode=CBPGA%2cCBSA%2cCBPSA%2cCUPA%2cCESA',
    nil,
    lambda { |doc| doc['CESA']['rates'][0][3] },
    lambda { |doc| doc['CESA']['rates'][0][1] ==
      '5000.0_and over_0.0_CAD_Balance'},
  ),
  HtmlSource.new(
    'ing',
    'ING Direct',
    'http://www.ingdirect.ca/en/save-invest/isa/index.html',
    'http://www.ingdirect.ca/en/datafiles/rates/isacad.html',
    nil,
    '//body'
  ),
  HtmlSource.new(
    'libro',
    'Libro',
    'http://www.libro.ca/rates/index.html',
    nil,
    'http://www.libro.ca/contact/locations.html',
    '//td' +
      '[preceding-sibling::td/text() = "$ 1,000 plus"]' +
      '[../../tr/td/text() = "Investment Savings"]'
  ),
  HtmlSource.new(
    'presidents_choice',
    'President\'s Choice',
    'http://www.banking.pcfinancial.ca/a/rates/savingsPlusAccountRate.page',
    nil,
    nil,
    '//td' + 
      '[preceding-sibling::td[contains(text(), "$1,000.01 and up")]]' +
      '[//p[@class = "pageTitle"]/span[contains(text(), "Interest Plus")]]'
  ),
  HtmlSource.new(
    'scotiabank',
    'Scotiabank',
    'http://www.scotiabank.com/rates/savings.html',
    nil,
    nil,
    '//a[em[contains(text(),"Scotia Power Savings Account")]]' +
      '/following-sibling::table[1]' +
      '/tr/td[text() = "$5,000 or more"]' +
      '/following-sibling::td/div'
  ),
  HtmlSource.new(
    'td',
    'TD Canada Trust',
    'http://www.tdcanadatrust.com/accounts/account_rates.jsp#highinterest',
    nil,
    nil,
    '//p[contains(.//text(), "TD High Interest Savings Account")]' +
      '/following-sibling::table[1]' +
      '/tr/th[text() = "$5,000 to $9,999.99"]' +
      '/following-sibling::td'
  ),
  HtmlSource.new(
    'rbc',
    'Royal Bank of Canada',
    'http://www.rbcroyalbank.com/rates/persacct.html#esavings',
    nil,
    nil,
    '//h3[.//text() = "RBC High Interest eSavings"]' +
      '/following-sibling::table' +
      '/tr/td[text() = "All balances"]' +
      '/following-sibling::td'
  ),
]
