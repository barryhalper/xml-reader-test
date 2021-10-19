require 'Nokogiri'

class AssessmentXml
  attr_accessor :xml_doc, :xml_nodes

  def initialize(file_name)
    @xml_doc    =  Nokogiri::XML(File.read(file_name))
    @xml_nodes  =  @xml_doc.descendant_elements
  end

  def node_names
    @xml_nodes.map{|node| node.name}
  end

  def grouped_nodes
    node_names.group_by{|i|i}
  end

  def to_count_hash
    grouped_nodes.map{|key, value| [key, value.length]}.to_h
  end

  def filter_occurence(by_one = true)
    by_one ? to_count_hash.select{|k,v| v ==1} : to_count_hash.select{|k,v| v > 1}
  end

  def filter_nodes(node_array)
    node_names.reject{ |k| node_array}
  end

  def attribute_nodes
    @xml_doc.reject{| node | node.element_children.nil? || node.element_children.length > 0}
  end
end

class Nokogiri::XML::Node
  def descendant_elements
    child_nodes = element_children.to_a
    child_nodes.concat(child_nodes.map(&:descendant_elements)).flatten
  end
end
