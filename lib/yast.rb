require "yast/version"
require 'yast/configuration'

# require "builder"
# require "net/http"
# require "xmlsimple"


module Yast
  extend Configuration

  # mattr_accessor :username, :password, :hash,
  #                :timefrom, :timeto, :typeid, :parentid


  class Record
    attr_accessor :id, :typeId, :timeCreated, :timeUpdated, :project,
                  :creator, :flags, :startTime, :endTime, :comment,
                  :isRunning, :phoneNumber, :outgoing
  end

  class Project
    attr_accessor :id, :name, :description, :primaryColor, :parentId,
                  :privileges, :timeCreated, :creator
  end

  class Folder
    attr_accessor :id, :name, :description, :primaryColor, :parentId,
                  :privileges, :timeCreated, :creator
  end


  def self.login
    unless username.nil? or password.nil?
      xml_string = generate_request('auth.login', {:user => username, :password => password})
      xml = get_xml(xml_string)
      self.hash = xml['hash'].first if xml.has_key? ('hash')
    end

    return !self.hash.nil?
  end

  def self.get_xml(xml_string)
    url = URI.parse( "http://www.yast.com/1.0/" )

    response = Net::HTTP.start(url.host, url.port) do |http|
      http.post("http://www.yast.com/1.0/", "request=#{xml_string}")
    end
    XmlSimple.xml_in(response.body)
  end

  def self.generate_request(request, list)
    target_object = ''
    xml = Builder::XmlMarkup.new( :target => target_object, :indent => 2 )

    xml.instruct! :xml
    xml.request('req' => request, 'id' => 133) do |b|
      list.each do |k, v|
        b.tag!( k, v)
      end
    end
    target_object
  end


  def self.get_records
    records = []
    unless username.nil? or hash.nil?
      request_hash = { :user => username, :hash => hash }
      request_hash['timeFrom']  = timefrom  if timefrom
      request_hash['timeTo']    = timefrom  if timeto
      request_hash['typeId']    = typeid    if typeid
      request_hash['parentId']  = parentid  if parentid

      xml_string = generate_request('data.getRecords', request_hash)
      xml = get_xml(xml_string)

      unless xml['objects'][0]['record'].nil?
        xml['objects'][0]['record'].each do |record|
          puts record.to_json
          r = Yast::Record.new

          r.id          = record['id']
          r.typeId      = record['typeId']
          r.timeCreated = Time.at(record['timeCreated'][0].to_i)
          r.timeUpdated = Time.at(record['timeUpdated'][0].to_i)
          r.project     = record['project']
          r.startTime   = Time.at(record['variables'][0]['v'][0].to_i)
          r.endTime     = Time.at(record['variables'][0]['v'][1].to_i)
          r.comment     = record['variables'][0]['v'][2]
          r.isRunning   = record['variables'][0]['v'][3] == 1
          r.phoneNumber = record['variables'][0]['v'][4]
          r.outgoing    = record['variables'][0]['v'][5] == 1

          records << r
        end
      end
    end
    records
  end

  def self.get_projects
    projects = []

    unless username.nil? or hash.nil?
      xml_string = generate_request( 'data.getProjects', {:user => username, :hash => hash} )
      xml = get_xml(xml_string)

      unless xml['objects'][0]['project'].nil?
        xml['objects'][0]['project'].each do |project|
          p = Yast::Project.new

          p.id            = project['id']
          p.name          = project['name']
          p.description   = project['description']
          p.primaryColor  = project['primaryColor']
          p.parentId      = project['parentId']
          p.privileges    = project['privileges']
          p.timeCreated   = Time.at(project['timeCreated'][0].to_i)
          p.creator       = project['creator']

          projects << p
        end
      end
    end
    projects
  end

  def self.get_folders
    folders = []

    unless username.nil? or hash.nil?
      xml_string = generate_request( 'data.getFolders', {:user => username, :hash => hash} )
      xml = get_xml(xml_string)

      unless xml['objects'][0]['folder'].nil?
        xml['objects'][0]['folder'].each do |folder|
          p = Yast::Project.new

          p.id            = folder['id']
          p.name          = folder['name']
          p.description   = folder['description']
          p.primaryColor  = folder['primaryColor']
          p.parentId      = folder['parentId']
          p.privileges    = folder['privileges']
          p.timeCreated   = Time.at(folder['timeCreated'][0].to_i)
          p.creator       = folder['creator']

          folders << p
        end
      end
    end
    folders
  end
end
