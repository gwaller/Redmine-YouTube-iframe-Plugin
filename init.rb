require 'redmine'


Redmine::Plugin.register :redmine_youtube_iframe do
	name 'Redmine Youtube iframe macro plugin'
	author 'Gareth Waller'
	description 'This plugin adds a youtube macro to Redmine that enables a wiki page author to embed a YouTube video.'
	version '1.0.0'
	url ''
	author_url ''
	
	Redmine::WikiFormatting::Macros.register do
		desc = "This macro allows an author to embed a YouTube video via an iframe.  Usage: {{youtube_iframe(&ltvideo id&gt;,[&lt;width&gt;,&lt;height&gt;,&lt;hd&gt;,&lt;start&gt;])}}.</pre>"
		macro :youtube_iframe do |contents, args|
			width = 480
			height = 390

			if args.length >= 1
				# Assign  id
				videoid = args[0].strip
			
				# Assign optional params
				if args[1] != nil 
					width = args[1].strip
				end
				if args[2] != nil 
					height = args[2].strip
				end
				hd = args[3] ? args[3].strip : nil
				start = args[4] ? args[4].strip : nil

				to_boolean = lambda { |string| return (string == true || string =~ (/(true|t|yes|y|1)$/i) ) ? true : false}

				# Build up the url with the params 
				videourl = 'http://www.youtube.com/embed/' + videoid
				if args.length > 1
					videourl += '?'
					videourl += to_boolean.call(hd) ? 'hd=1&':''
					videourl += start ? 'start=' + start + '&':''
					# chop the last  char - this will either be a redundant & or the ? if the user didn't specify any params
					videourl = videourl.chop
				end	
				
				out = <<"EOF"
				<iframe width="#{width}" height="#{height}" src="#{videourl}" frameborder="0" allowfullscreen></iframe>
EOF
			else
				out = "<pre>Invalid syntax used for the YouTube iframe macro, missing mandatory param url. Usage: {{youtube_iframe(&ltvideo url&gt;,[&lt;width&gt;,&lt;height&gt;,&lt;hd&gt;,&lt;start&gt;])}}</pre>"
			end

			return out
		end
	end
end
