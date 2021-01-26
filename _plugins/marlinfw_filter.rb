module Jekyll
  module MarlinSiteFilter
    def codes_desc(input)
      out = input[0]
      if input.size > 1
        re1 = /([GM])(\d+).*$/
        doc1 = out.gsub(re1, '\2')
        doc2 = input.last.gsub(re1, '\2')
        out += doc2.to_i - doc1.to_i < 10 ? '-' : ', '
        out += input.last
      end
      out
    end

  end
end

Liquid::Template.register_filter(Jekyll::MarlinSiteFilter)
