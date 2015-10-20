# -*- coding: utf-8 -*-
require ('builder')

BOOKS = {
  'Gn' => 'Genesis',
  'Ex' => 'Exodus',
  'Lv' => 'Leviticus',
  'Nm' => 'Numeri',
  'Dt' => 'Deuteronomium',
  'Jos' => 'Josue',
  'Jdc' => 'Judicum',
  'Rt' => 'Ruth',
  '1Rg' => 'Regum I',
  '2Rg' => 'Regum II',
  '3Rg' => 'Regum III',
  '4Rg' => 'Regum IV',
  '1Par' => 'Paralipomenon I',
  '2Par' => 'Paralipomenon II',
  'Esr' => 'Esdræ',
  'Neh' => 'Nehemiæ',
  'Tob' => 'Tobiæ',
  'Jdt' => 'Judith',
  'Est' => 'Esther',
  'Job' => 'Job',
  'Ps' => 'Psalmi',
  'Pr' => 'Proverbia',
  'Ecl' => 'Ecclesiastes',
  'Ct' => 'Canticum Canticorum',
  'Sap' => 'Sapientia',
  'Sir' => 'Ecclesiasticus',
  'Is' => 'Isaias',
  'Jr' => 'Jeremias',
  'Lam' => 'Lamentationes',
  'Bar' => 'Baruch',
  'Ez' => 'Ezechiel',
  'Dn' => 'Daniel',
  'Os' => 'Osee',
  'Joel' => 'Joël',
  'Am' => 'Amos',
  'Abd' => 'Abdias',
  'Jon' => 'Jonas',
  'Mch' => 'Michæa',
  'Nah' => 'Nahum',
  'Hab' => 'Habacuc',
  'Soph' => 'Sophonias',
  'Agg' => 'Aggæus',
  'Zach' => 'Zacharias',
  'Mal' => 'Malachias',
  '1Mcc' => 'Machabæorum I',
  '2Mcc' => 'Machabæorum II',
  'Mt' => 'Matthæus',
  'Mc' => 'Marcus',
  'Lc' => 'Lucas',
  'Jo' => 'Joannes',
  'Act' => 'Actus Apostolorum',
  'Rom' => 'ad Romanos',
  '1Cor' => 'ad Corinthios I',
  '2Cor' => 'ad Corinthios II',
  'Gal' => 'ad Galatas',
  'Eph' => 'ad Ephesios',
  'Phlp' => 'ad Philippenses',
  'Col' => 'ad Colossenses',
  '1Thes' => 'ad Thessalonicenses I',
  '2Thes' => 'ad Thessalonicenses II',
  '1Tim' => 'ad Timotheum I',
  '2Tim' => 'ad Timotheum II',
  'Tit' => 'ad Titum',
  'Phlm' => 'ad Philemonem',
  'Hbr' => 'ad Hebræos',
  'Jac' => 'Jacobi',
  '1Ptr' => 'Petri I',
  '2Ptr' => 'Petri II',
  '1Jo' => 'Joannis I',
  '2Jo' => 'Joannis II',
  '3Jo' => 'Joannis III',
  'Jud' => 'Judæ',
  'Apc' => 'Apocalypsis'
}

builder = Builder::XmlMarkup.new
builder.instruct!(:xml, version: '1.0', encoding: 'UTF-8')

Dir['latin/*.lat'].to_a.sort.each do |filename|
  next if filename =~~ /.*\.lat/
  file = File.open(filename, 'r')
  book = Books[File.basename(filename, '.lat')]
  file.readlines.each do |line|
    # The original file has codepage 1252 encoding
    # Lets get rid of that
    line.force_encoding('windows-1252').encode!('utf-8')

  end
end
