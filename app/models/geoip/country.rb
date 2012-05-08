module Geoip
  class Country < Geoip::Base

    set_table_name 'geoip_country'

    IPADDR_REGEX = /^([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])(\.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])){3}$/
    MULTS = [256**3, 256**2, 256**1, 256**0]
    DEFAULT_CODE = 'us'

    def self.to_dec(ip)
      # Convert a given IP address into decimal form - very easy!
      dec = 0
      ip.split('.').each_with_index do |chunk, idx|
        dec += chunk.to_i*MULTS[idx]
      end
      return dec
    end

    def self.find_by_ip(ip)

      # Quick check if we're dealing with a valid ip and if not use default
      return DEFAULT_CODE unless IPADDR_REGEX.match(ip)

      # Convert to decimal and try looking up the first matching row
      dec = to_dec(ip)
      geo_located = self.where(:start_decimal => '>=%d' % dec, :end_decimal => '<=%d' % dec).first

      # See if we've got a code to return
      return geo_located.country_code unless geo_located.nil?

      # Return a default in all other cases
      return DEFAULT_CODE

    end

  end
end
