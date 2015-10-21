# -*- coding: utf-8 -*-
require('builder')

class LatinConverter

  BOOKS = {
           'Gn'    => ['GEN','Genesis'],
           'Ex'    => ['EXO','Exodus'],
           'Lv'    => ['LEV','Leviticus'],
           'Nm'    => ['NUM','Numeri'],
           'Dt'    => ['DEU','Deuteronomium'],
           'Jos'   => ['JOS','Josue'],
           'Jdc'   => ['JDG','Judicum'],
           'Rt'    => ['RUT','Ruth'],
           '1Rg'   => ['1SA','Regum I'],
           '2Rg'   => ['2SA','Regum II'],
           '3Rg'   => ['1KI','Regum III'],
           '4Rg'   => ['2KI','Regum IV'],
           '1Par'  => ['1CH','Paralipomenon I'],
           '2Par'  => ['2CH','Paralipomenon II'],
           'Esr'   => ['EZR','Esdræ'],
           'Neh'   => ['NEH','Nehemiæ'],
           'Tob'   => ['TOB','Tobiæ'],
           'Jdt'   => ['JDT','Judith'],
           'Est'   => ['EST','Esther'],
           'Job'   => ['JOB','Job'],
           'Ps'    => ['PSA','Psalmi'],
           'Pr'    => ['PRO','Proverbia'],
           'Ecl'   => ['ECC','Ecclesiastes'],
           'Ct'    => ['SNG','Canticum Canticorum'],
           'Sap'   => ['WIS','Sapientia'],
           'Sir'   => ['SIR','Ecclesiasticus'],
           'Is'    => ['ISA','Isaias'],
           'Jr'    => ['JER','Jeremias'],
           'Lam'   => ['LAM','Lamentationes'],
           'Bar'   => ['BAR','Baruch'],
           'Ez'    => ['EZK','Ezechiel'],
           'Dn'    => ['DAN','Daniel'],
           'Os'    => ['HOS','Osee'],
           'Joel'  => ['JOL','Joël'],
           'Am'    => ['AMO','Amos'],
           'Abd'   => ['OBA','Abdias'],
           'Jon'   => ['JON','Jonas'],
           'Mch'   => ['MIC','Michæa'],
           'Nah'   => ['NAM','Nahum'],
           'Hab'   => ['HAB','Habacuc'],
           'Soph'  => ['ZEP','Sophonias'],
           'Agg'   => ['HAG','Aggæus'],
           'Zach'  => ['ZEC','Zacharias'],
           'Mal'   => ['MAL','Malachias'],
           '1Mcc'  => ['1MA','Machabæorum I'],
           '2Mcc'  => ['2MA','Machabæorum II'],
           'Mt'    => ['MAT','Matthæus'],
           'Mc'    => ['MRK','Marcus'],
           'Lc'    => ['LUK','Lucas'],
           'Jo'    => ['JHN','Joannes'],
           'Act'   => ['ACT','Actus Apostolorum'],
           'Rom'   => ['ROM','ad Romanos'],
           '1Cor'  => ['1CO','ad Corinthios I'],
           '2Cor'  => ['2CO','ad Corinthios II'],
           'Gal'   => ['GAL','ad Galatas'],
           'Eph'   => ['EPH','ad Ephesios'],
           'Phlp'  => ['PHP','ad Philippenses'],
           'Col'   => ['COL','ad Colossenses'],
           '1Thes' => ['1TH','ad Thessalonicenses I'],
           '2Thes' => ['2TH','ad Thessalonicenses II'],
           '1Tim'  => ['1TI','ad Timotheum I'],
           '2Tim'  => ['2TI','ad Timotheum II'],
           'Tit'   => ['TIT','ad Titum'],
           'Phlm'  => ['PHM','ad Philemonem'],
           'Hbr'   => ['HEB','ad Hebræos'],
           'Jac'   => ['JAS','Jacobi'],
           '1Ptr'  => ['1PE','Petri I'],
           '2Ptr'  => ['2PE','Petri II'],
           '1Jo'   => ['1JN','Joannis I'],
           '2Jo'   => ['2JN','Joannis II'],
           '3Jo'   => ['3JN','Joannis III'],
           'Jud'   => ['JUD','Judæ'],
           'Apc'   => ['REV','Apocalypsis']
          }

  def self.build_xml_file
    v = build_verses_hash
    xml = build_xml(v)
    file = File.open('lat-clementine-vul.usfx.xml', 'w')
    file.write xml
    file.close
  end

  def self.build_verses_hash
    verses = {}
    Dir['latin/*.lat'].to_a.sort.each do |filename|
      if filename =~ /.*\.lat/
        file = File.open(filename, 'r')
        name = File.basename(filename, '.lat')
        bid = BOOKS[name][0]
        verses[bid] ||= {}
        file.readlines.each do |line|
          # The original file has codepage 1252 encoding
          # Lets get rid of that
          line.force_encoding('windows-1252').encode!('utf-8')
          # Get rid of annoying characters
          line.gsub!(/[<\/\\\[\]]*/,'').gsub!(/>/,' ')
          # Get chapter and verse number
          cn, vn = line.slice!(/\d+:\d+/).split(':')
          verses[bid][cn] ||= {}
          verses[bid][cn][vn] = line.rstrip
        end
        file.close
      end
    end
    return verses
  end

  def self.build_xml(verses)
    builder = Builder::XmlMarkup.new
    builder.instruct!(:xml, version: '1.0', encoding: 'UTF-8')
    xml = builder.usfx('xmlns:xsi' => 'http://eBible.org/usfx.xsd', 'xsi:noNamespaceSchemaLocation' => 'usfx.xsd') do |usfx|
      BOOKS.each do |f, bid|
        usfx.book(id: bid[0]) do |book|
          book.h(bid[1])
          chapters = verses[bid[0]]
          chapters.each do |cn, verses|
            book.c(id: cn)
            verses.each do |vn, text|
              book.v(id: vn)
              book << text
              book.ve
            end
          end
        end
      end
    end
    return xml
  end

end
