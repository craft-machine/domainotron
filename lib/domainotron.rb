require 'domainotron/version'

module Domainotron
  class << self
    DOT = '.'.freeze

    def get_domain(url, remove_www: true)
      return nil unless url

      normalized = url.to_s.sub(/:\d+{2,6}/, '').sub(%r{/\Z}, '').strip

      unless normalized =~ %r{^(http://|https://|//)}
        normalized = '//' + normalized
      end

      begin
        domain = URI.parse(normalized).host
      rescue URI::InvalidURIError
        return nil
      end

      return nil unless domain

      domain = domain.gsub(/^www\./, '') if remove_www

      domain
    end

    def get_domain_variants(url, remove_www: true)
      normalized = get_domain(url, remove_www: remove_www)
      return nil unless normalized

      begin
        domain = PublicSuffix.parse(normalized)
      rescue PublicSuffix::DomainNotAllowed
        return nil
      end

      domain.trd ? collect_subdomains(domain) : [domain.domain]
    end

    private

    def collect_subdomains(domain)
      domain.trd.split(DOT).reverse
            .reduce([]) { |acc, subdomain| acc << [subdomain, acc.last.to_s].join(DOT) }
            .map { |subdomain| subdomain + domain.domain }
            .unshift(domain.domain)
    end
  end
end
