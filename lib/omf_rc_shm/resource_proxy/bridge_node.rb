# Copyright (c) 2012 National ICT Australia Limited (NICTA).
# This software may be used and distributed solely under the terms of the MIT license (License).
# You should find a copy of the License in LICENSE.TXT or at http://opensource.org/licenses/MIT.
# By downloading or using this software you accept the terms and the liability disclaimer in the License.

module OmfRc::ResourceProxy::BridgeNode
  include OmfRc::ResourceProxyDSL
  # @!macro extend_dsl

  register_proxy :bridge_node

  # Created applications
  #
  # @example
  #   [{ name: 'my_app', type: 'application', uid: 'E232ER1' }]
  # @return [Array<Hash>]
  # @!macro request
  # @!method request_applications
  request :applications do |node|
    node.children.find_all { |v| v.type =~ /application/ }.map do |v|
      { name: v.hrn, type: v.type, uid: v.uid }
    end.sort { |x, y| x[:name] <=> y[:name] }
  end

  # @!endgroup

  # @!macro group_hook
  # @!method before_ready
  hook :before_ready do |node|
    info "#{node.uid} is now creating some default apps "
  end
  # @!endgroup
end
