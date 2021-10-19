require 'Nokogiri'
require_relative '../assessment_xml'


RSpec.describe AssessmentXml do
  subject = AssessmentXml.new("epc.xml")
  context 'when reading the xml file' do


    let(:attribute_nodes_names) {
      attribute_nodes.map{|node| node.name}
    }


    let(:reject_nodes) {
      %i[
      Address
      Address-Line-2
      Address-Line-3
      Completion-Date
      Contact-Address
      Schema-Version-Original
      Country-Code
      E-Mail
      Name
      RRN
      RdSAP-Report
      Region-Code
      Registration-Date
      Report-Header
      SAP-Data
      SAP-Version
      Scheme-Name
      Scheme-Web-Site
      Status
      Telephone
      UPRN
      ]
    }

    let(:grouped_nodes_hash) {
      subject.to_count_hash
    }

    it 'xml data is returned' do
      expect(subject.xml_doc).to be_truthy
    end

    it 'can recursive get all the child elements into an array' do
      expect(subject.xml_nodes.class).to eq(Array)
      expect(subject.xml_nodes.length).to eq(291)
    end

    it 'can extract only the nodes that do not have any children' do
      expect(subject.attribute_nodes.length).to be < subject.xml_nodes.length
    end

    it 'can group the array by unique elements to reduce the size' do
      expect(subject.grouped_nodes.length).to eq(206)
    end

    it 'can produce a hash of the count the number of times a node appears' do
      expect(grouped_nodes_hash["Description"]).to eq(14)
      expect(grouped_nodes_hash["Typical-Saving"]).to eq(3)
      expect(grouped_nodes_hash["Wall"]).to eq(2)
      expect(grouped_nodes_hash["Improvement"]).to eq(3)
      expect(grouped_nodes_hash["Floor"]).to eq(4)
    end

    it 'can filter nodes for those that have one occurence' do
      expect(subject.filter_occurence.to_a.length).to be < grouped_nodes_hash.to_a.length
    end

    it 'can filter nodes for those that have more than one occurence' do
      expect(subject.filter_occurence(false).to_a.length).not_to eq(subject.filter_occurence.to_a.length)
    end

    xit 'can filter array based on rejected values' do
      expect(subject.filter_nodes(reject_nodes).to_a.length).to eq(10)
    end

  end
end



# Recursive 2
