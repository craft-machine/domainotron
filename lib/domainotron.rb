require "domainotron/version"

module Domainotron
  def self.get_domain(url, remove_www: true)
    normalized = url.sub(/:\d+{2,6}/, '').sub(/\/\Z/, '')

    unless url.match /^(http:\/\/|https:\/\/|\/\/)/
      normalized = '//' + normalized
    end

    domain = URI.parse(normalized).host

    if remove_www
      domain = domain.gsub('www.', '')
    end

    domain
  end
end
