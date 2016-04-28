class ExcelJob < ActiveJob::Base
  queue_as :pricer

  def perform(upload)
    uploads = []
    Dir.mktmpdir do |tempdir|
      command = "j #{upload.price.file.path} -l"
      ProcessCommon.popen3(command) do |i, o, e, t|
        o.readlines.each do |sheet_name|
          sheet_name.chomp!
          notes = sheet_name
          path = File.join(tempdir, sheet_name)
          command = "j #{upload.price.file.path} -s '#{sheet_name}' -o '#{path}'"
          begin
            ProcessCommon.popen3(command)
          rescue StandardError
            command = "in2csv '#{upload.price.file.path}' > '#{path}'"
            ProcessCommon.popen3(command)
          end
          uploads << Upload.create!(price: File.open(path), upload: upload, job_type: :excel, notes: notes,
                                    command: command)
        end
      end

      uploads.each do |upload|
        ProcessCommon.perform(upload)
      end
    end

  end
end
