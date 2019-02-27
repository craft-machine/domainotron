require "domainotron/version"

module Domainotron
  DOT = '.'.freeze

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

    return nil unless domain

    if remove_www
      domain = domain.gsub(/^www\./, '')
    end

    domain
  end

  def self.get_domain_variants(url, remove_www: true)
    normalized = get_domain(url, remove_www: remove_www)
    return nil unless normalized

    begin
      domain = PublicSuffix.parse(normalized)
    rescue PublicSuffix::DomainNotAllowed
      return nil
    end
    variants = []

    parts = domain.name.split(DOT)
    loop do
      variant = parts.join(DOT)
      variants << variant

      break if variant == domain.domain || parts.empty?
      parts.shift
    end

    variants
  end
end
