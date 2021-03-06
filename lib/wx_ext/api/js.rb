# encoding: UTF-8

require 'digest'
require 'wx_ext/helper'

module WxExt
  # Weixin api
  #
  # @author FuShengYang
  module Api
    # User api of weixin.
    #
    # @author FuShengYang
  module Js
      # Get js api ticket.
      #
      # @param [Enumerable<String>] access_token
      # @return [Hash] Json based hash.
      def get_jsapi_ticket(access_token)
        url = "https://api.weixin.qq.com/cgi-bin/ticket/getticket?access_token=#{access_token}&type=jsapi"
        Helper.http_get(url, { accept: :json })
      end

      # Get js api config hash.
      #
      # @param [Enumerable<String>] access_token
      # @param [Enumerable<String>] url
      # @param [Enumerable<String>] app_id
      # @return [Hash] Json based hash.
      def get_jsapi_config(access_token, url, app_id, jsapi_ticket)
        timestamp = set_timestamp
        noncestr = set_noncestr
        str = "jsapi_ticket=#{jsapi_ticket}&noncestr=#{noncestr}&timestamp=#{timestamp}&url=#{url}"
        signature = Digest::SHA1.hexdigest(str)
        config_hash = {
          app_id: app_id,
          timestamp: timestamp,
          noncestr: noncestr,
          signature: signature,
          jsapi_ticket: jsapi_ticket,
          url: url,
          str: str
        }
      end

      private

      # Set the noncestr of 16 byte.
      #
      # @return [String] 16 byte str.
      def set_noncestr
        [*'a'..'z',*'0'..'9',*'A'..'Z'].sample(16).join
      end

      # Set the timestamp.
      #
      # @return [String] timestamp str.
      def set_timestamp
        Time.now.to_i.to_s
      end

      extend self
    end
  end
end
