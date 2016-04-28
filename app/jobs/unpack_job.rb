require 'open3'

class UnpackJob < ActiveJob::Base
  queue_as :pricer

  def perform(upload)

    uploads = []
    command = ''

    Dir.mktmpdir do |tempdir|
      case upload.content_type
        when /zip/
          command = "unzip #{upload.price.path} -d #{tempdir}"
          begin
            ProcessCommon.popen3 command
          rescue StandardError
            Dir.mktmpdir do |tempdir|
              path = File.join(tempdir, upload.original_filename)
              command = "zip -FF '#{upload.price.path}' --out '#{path}'"
              notes = ''
              ProcessCommon.popen3 command
              Dir.mktmpdir do |tempdir|
                command = "unzip '#{path}' -d '#{tempdir}'"
                ProcessCommon.popen3 command
              end
            end
          end
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
