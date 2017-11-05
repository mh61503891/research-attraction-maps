require 'open-uri'
require 'rexml/document'

class KAKEN

  def self.get(keywords)
    entries = []
    @xml = API.search(keywords)
    @doc = REXML::Document.new(@xml)
    REXML::XPath.match(@doc, 'grantAwards/grantAward').each do |grant|
      id = grant.attribute('id').value
      title = grant.elements['summary'].elements['title'].text
      institution = grant.elements['summary'].elements['institution'].text
      members = []
      grant.elements['summary'].children.select{ |c|
        c.name == 'member'
      }.each do |member|
        # binding.pry
        # institution2 = member.elements['institution']
        # p institution2
        # name =
        members << {
          institution: member.elements['institution']&.text,
          department: member.elements['department']&.text,
          jobTitle: member.elements['jobTitle']&.text,
          name: member.elements['personalName'].elements['fullName'].text
        }
      end


      # .map{|m|m.elements['personalName'].elements['fullName'].text}


      # grant.elements['summary'].children.select{|c| c.name == 'member'}.map{|m|m.elements['personalName'].elements['fullName'].text}

      # binding.pry
      # p REXML::XPath.match(grant, 'summary/title')
      entries << {
        id: id,
        title: title,
        institution: institution,
        members: members
      }
    end
    return entries
  rescue REXML::ParseException => e
    return {message: e.to_s}
  end

  class API
    def self.search(keywords)
      Rails.cache.fetch("models/kaken/api/search/#{CGI::escape(keywords)}",  expires_in:24.hours) do
        open("https://kaken.nii.ac.jp/opensearch/?appid=#{ENV['CINII_API_KEY']}&format=xml&kw=#{CGI::escape(keywords)}"){ |io|
        io.read
        }
      end
    end
  end

end
