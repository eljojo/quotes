require 'json'
# inspired by script from https://raw.github.com/benbalter/benbalter.github.com/b82fbeb27f95ff7d61ab30be2005b1c11a952b3b/_plugins/generate-json.rb

# note: this is dirty as fuck

module Jekyll
  class Post
    def write_json(dest)
      # add `json: false` to YAML to prevent JSONification
      if data.has_key? "json" and !data["json"]
        return
      end

      path = File.join(site.dest, 'api', url + '.json')

      # render post using no template(s)
      render({}, site.site_payload)

      # prepare output for JSON
      output = to_liquid
      output["next"] = output["next"].id unless output["next"].nil?
      output["previous"] = output["previous"].id unless output["previous"].nil?

      FileUtils.mkdir_p(File.dirname(path))
      File.open(path, 'w') do |f|
        f.write(output.to_json)
      end
    end

    def write(dest)
      super(dest)
      write_json(dest)
    end
  end
end
