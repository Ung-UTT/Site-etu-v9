#FIXME: "Hardcore monkey patch", ne survivra pas aux montées en version de Rails
#       Il faut trouver une solution qui utilise l'API de Rails
#       Via config/application.rb ou via la gestion des exceptions

module ActionView
  class PathResolver < Resolver
    private

    def query(path, details, formats)
      # details étant un hash gelé (on ne peut pas le modifier), je le duplique pour pouvoir le modifier
      unfrozen_details = details.dup
      unfrozen_details[:formats] = details[:formats].dup
      if details[:formats].include?(:mobile) # Si le format est [:mobile]
        unfrozen_details[:formats] = unfrozen_details[:formats].push(:html) # On ajout :html comme format possible
      end
 
      query = build_query(path, unfrozen_details) # Et on utilise la copie de details
      templates = []
      sanitizer = Hash.new { |h,k| h[k] = Dir["#{File.dirname(k)}/*"] }

      Dir[query].each do |p|
        next if File.directory?(p) || !sanitizer[p].include?(p)

        handler, format = extract_handler_and_format(p, formats)
        contents = File.open(p, "rb") { |io| io.read }

        templates << Template.new(contents, File.expand_path(p), handler,
          :virtual_path => path.virtual, :format => format, :updated_at => mtime(p))
      end
      
      # Si ya 2 templates, ya le :mobile et le :html
      if templates.size > 1
        templates = templates.select{|t| t.identifier =~ /mobile/} # Si le template mobile existe, enlever les autres
      end

      templates
    end
  end
end
