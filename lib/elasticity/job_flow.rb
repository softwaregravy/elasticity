module Elasticity

  class JobFlow

    attr_accessor :name
    attr_accessor :jobflow_id
    attr_accessor :state
    attr_accessor :steps
    attr_accessor :created_at
    attr_accessor :started_at
    attr_accessor :ready_at
    attr_accessor :instance_count
    attr_accessor :master_instance_type
    attr_accessor :slave_instance_type
    attr_accessor :last_state_change_reason

    def initialize
      @steps = []
    end

    # Create a jobflow from an AWS <member> (Nokogiri::XML::Element):
    #   /DescribeJobFlowsResponse/DescribeJobFlowsResult/JobFlows/member
    def self.from_member_element(xml_element)
      jobflow = JobFlow.new
      jobflow.name = xml_element.xpath("./Name").text.strip
      jobflow.jobflow_id = xml_element.xpath("./JobFlowId").text.strip
      jobflow.state = xml_element.xpath("./ExecutionStatusDetail/State").text.strip
      jobflow.last_state_change_reason = xml_element.xpath("./ExecutionStatusDetail/LastStateChangeReason").text.strip
      jobflow.steps = JobFlowStep.from_members_nodeset(xml_element.xpath("./Steps/member"))
      jobflow.created_at = Time.parse(xml_element.xpath("./ExecutionStatusDetail/CreationDateTime").text.strip)
      started_at = xml_element.xpath("./ExecutionStatusDetail/StartDateTime").text.strip
      jobflow.started_at = (started_at == "") ? (nil) : (Time.parse(started_at))
      ready_at = xml_element.xpath("./ExecutionStatusDetail/ReadyDateTime").text.strip
      jobflow.ready_at = (ready_at == "") ? (nil) : (Time.parse(ready_at))
      jobflow.instance_count = xml_element.xpath("./Instances/InstanceCount").text.strip
      jobflow.master_instance_type = xml_element.xpath("./Instances/MasterInstanceType").text.strip
      jobflow.slave_instance_type = xml_element.xpath("./Instances/SlaveInstanceType").text.strip
      jobflow
    end

    # Create JobFlows from a collection of AWS <member> nodes (Nokogiri::XML::NodeSet):
    #   /DescribeJobFlowsResponse/DescribeJobFlowsResult/JobFlows
    def self.from_members_nodeset(members_nodeset)
      jobflows = []
      members_nodeset.each do |member|
        jobflows << from_member_element(member)
      end
      jobflows
    end

  end

end