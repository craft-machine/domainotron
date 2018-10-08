require "domainotron/version"

module Domainotron
  def self.get_domain(url, remove_www: true)
    return nil unless url

    normalized = url.to_s.sub(/:\d+{2,6}/, '').sub(/\/\Z/, '').strip

    unless normalized.match /^(http:\/\/|https:\/\/|\/\/)/
      normalized = '//' + normalized
    end

    begin
      domain = URI.parse(normalized).host
    rescue URI::InvalidURIError
      return nil
    end

    if remove_www
      domain = domain.gsub(/^www\./, '')
    end

    domain
  end
end
