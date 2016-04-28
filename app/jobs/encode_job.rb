class EncodeJob < ActiveJob::Base
  queue_as :pricer

  def perform(upload)

    uploads = []
    str = IO.read(upload.price.file.path, 1000)
    encodings = CharlockHolmes::EncodingDetector.detect_all(str)
    encoding = encodings.find{|encoding| encoding[:confidence] > 75 || encoding[:language] == "ru"}
    encoding = encodings.first if encoding.nil?
    #upload.update!(encoding: encoding.to_json)
    #redirect_to :back

    Dir.mktmpdir do |tempdir|
      path = File.join(tempdir, upload.original_filename)
      notes = encoding.to_json
      command = "iconv -f #{encoding[:encoding]} -t UTF-8 '#{upload.price.file.path}' > '#{path}'"
      ProcessCommon.popen3(command)
      uploads << Upload.create!(price: File.open(path), upload: upload, job_type: :encode, notes: notes,
                     command: command)
    end

    uploads.each do |upload|
      FormatJob.perform_later(upload)
    end
  end

end
