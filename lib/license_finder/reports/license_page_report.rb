module LicenseFinder
  class LicensePageReport < ErbReport
    private

    def template_name
      'license_page_report'
    end

    def bootstrap
      TEMPLATE_PATH.join('bootstrap.css').read
    end
  end
end
