require 'open3'

class UnpackJob < ActiveJob::Base
  queue_as :default

  def perform(upload)

    uploads = []
    command = ''

    Dir.mktmpdir do |tempdir|
      case upload.content_type
        when /zip/
          command = "unzip #{upload.price.path} -d #{tempdir}"
          ProcessCommon.popen3 command
        when /7z/
          command = "7zr e #{upload.price.path} -o#{tempdir}"
          ProcessCommon.popen3 command
        when /rar/
          command = "unrar e #{upload.price.path} #{tempdir}"
          ProcessCommon.popen3 command
        else
          raise 'Unknown archive type'
      end

      Dir["#{tempdir}/**/*"].each do |file|
        unless File.directory?(file)
          notes = file.dup
          notes.slice!(tempdir)
          notes.slice!(0)
          uploads << Upload.create!(price: File.open(file), upload: upload, job_type: :unpack, notes: notes,
                                    command: command)
        end
      end

    end

    uploads.each do |upload|
      ProcessCommon.perform(upload)
    end

  end
end
