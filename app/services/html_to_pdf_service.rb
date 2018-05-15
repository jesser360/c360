class HtmlToPdfService
  def self.convert(html, static_url: "https://localhost.com")
    md5html = Digest::MD5.hexdigest(html)
    html_filename = Rails.root.join("tmp","cache","#{md5html}.html")
    pdf_filename = Rails.root.join("tmp","cache","#{md5html}.pdf")
    @render_to_pdf = nil
    begin
      File.write(html_filename, html)
      `wkhtmltopdf -s Legal --encoding utf-8 --margin-left 8mm --margin-right 8mm --footer-right "Page [page] of [toPage]" --footer-font-size 10 #{html_filename} #{pdf_filename}`
      @render_to_pdf = File.read(pdf_filename)
    ensure
      File.delete(html_filename) rescue nil
      File.delete(pdf_filename) rescue nil
    end
    @render_to_pdf
  end

end
