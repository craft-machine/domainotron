require 'domainotron/version'

module Domainotron
  class << self
    DOT = '.'.freeze

    def get_domain(url, remove_www: true)
      return unless url

      normalized = url.to_s.sub(/:\d+{2,6}/, '').sub(%r{/\Z}, '').strip

      normalized = '//' + normalized unless normalized =~ %r{^(http://|https://|//)}

      begin
        domain = URI.parse(normalized).host
      rescue URI::InvalidURIError
        return
      end

      return unless domain

      domain = domain.gsub(/^www\./, '') if remove_www

      domain
    end

    def get_domain_variants(url, remove_www: true)
      normalized = get_domain(url, remove_www: remove_www)
      return unless normalized

      begin
        domain = PublicSuffix.parse(normalized)
      rescue PublicSuffix::DomainNotAllowed
        return
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
