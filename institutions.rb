require 'source'

Institutions =
[
  HtmlSource.new(
    :id => 'ally',
    :name => 'Ally',
    :human_uri => 'http://www.ally.ca/en/savings/high-interest-savings-account/compare-hisa-rates.html',
    :target => '//td' +
      '[@id = "Ally"]' +
      '[//title[contains(text(), "High Interest Savings Account")]]'
  ),
  JavascriptSource.new(
    :id => 'bmo',
    :name => 'Bank of Montreal',
    :human_uri => 'http://www.bmo.com/home/personal/banking/rates/bank-accounts',
    :robot_uri => 'http://www.bmo.com/bmocda/templates/json_bankacct_include.jsp',
    :target => lambda { |doc| doc['OPRS_CA']['99999999.99']['value'] },
    :checks => [
    ]
  ),
  HtmlSource.new(
    :id => 'canadian_tire',
    :name => 'Canadian Tire',
    :human_uri => 'https://www.myctfs.com/Products/HighIntSavings/',
    :robot_uri => 'https://www.myctfs.com/Rates/SavingsRates/',
    :target => '//td' +
      '[preceding-sibling::th/text() = "High Interest Savings"]'
  ),
  JavascriptSource.new(
    :id => 'cibc',
    :name => 'CIBC',
    :human_uri => 'http://www.cibc.com/ca/chequing-savings/compare-accounts.html?asa',
    :robot_uri => 'https://www.cibconline.cibc.com/olbtxn/rds?lobId=3&sourceProductCode=CBPGA%2cCBSA%2cCBPSA%2cCUPA%2cCESA',
    :target => lambda { |doc| doc['CESA']['rates'][0][3] },
    :checks => [
      lambda { |doc| doc['CESA']['rates'][0][1] ==
        '5000.0_and over_0.0_CAD_Balance'}
    ]
  ),
  HtmlSource.new(
    :id => 'ing',
    :name => 'ING Direct',
    :human_uri => 'http://www.ingdirect.ca/en/save-invest/isa/index.html',
    :robot_uri => 'http://www.ingdirect.ca/en/datafiles/rates/isacad.html',
    :target => '//body'
  ),
  HtmlSource.new(
    :id => 'libro',
    :name => 'Libro',
    :human_uri => 'http://www.libro.ca/rates/index.html',
    :regional_uri => 'http://www.libro.ca/contact/locations.html',
    :target => '//td' +
      '[preceding-sibling::td/text() = "$ 1,000 plus"]' +
      '[../../tr/td/text() = "Investment Savings"]'
  ),
  HtmlSource.new(
    :id => 'presidents_choice',
    :name => 'President\'s Choice',
    :human_uri => 'http://www.banking.pcfinancial.ca/a/rates/savingsPlusAccountRate.page',
    :target => '//td' + 
      '[preceding-sibling::td[contains(text(), "$1,000.01 and up")]]' +
      '[//p[@class = "pageTitle"]/span[contains(text(), "Interest Plus")]]'
  ),
  HtmlSource.new(
    :id => 'scotiabank',
    :name => 'Scotiabank',
    :human_uri => 'http://www.scotiabank.com/rates/savings.html',
    :target => '//a[em[contains(text(),"Scotia Power Savings Account")]]' +
      '/following-sibling::table[1]' +
      '/tr/td[text() = "$5,000 or more"]' +
      '/following-sibling::td/div'
  ),
  HtmlSource.new(
    :id => 'td',
    :name => 'TD Canada Trust',
    :human_uri => 'http://www.tdcanadatrust.com/accounts/account_rates.jsp#highinterest',
    :target => '//p[contains(.//text(), "TD High Interest Savings Account")]' +
      '/following-sibling::table[1]' +
      '/tr/th[text() = "$5,000 to $9,999.99"]' +
      '/following-sibling::td'
  ),
  HtmlSource.new(
    :id => 'rbc',
    :name => 'Royal Bank of Canada',
    :human_uri => 'http://www.rbcroyalbank.com/rates/persacct.html#esavings',
    :target => '//h3[.//text() = "RBC High Interest eSavings"]' +
      '/following-sibling::table' +
      '/tr/td[text() = "All balances"]' +
      '/following-sibling::td'
  ),
]
