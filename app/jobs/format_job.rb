class FormatJob < ActiveJob::Base
  queue_as :default

  def perform(upload)

    notes = ''

    Dir.mktmpdir do |tempdir|
      path = File.join(tempdir, upload.price.file.original_filename)
      command = "python3 #{File.join(Rails.root, 'system', 'python_sniffer.py')} #{upload.price.path} #{path}"
      ProcessCommon.popen3 command do |i, o, e, t|
        notes = JSON.parse(o.readlines.first)
      end
      upload = Upload.create!(price: File.open(path), upload: upload, job_type: :format, notes: notes,
                                command: command)

      if upload.file_size > 100
        ActionCable.server.broadcast 'messages', upload: upload
      end
    end


  end
end
