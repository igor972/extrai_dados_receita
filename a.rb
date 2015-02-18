# encoding: utf-8
# link: http://www.receita.fazenda.gov.br/PessoaJuridica/CNPJ/cnpjreva/Cnpjreva_Solicitacao2.asp

require 'rubygems'
require 'mechanize'
require 'open-uri'

files_names = Dir.glob("empresas/*.htm")

str1 = "empresas/"
str2 = ".htm"


files_names.each_with_index do |name, index|
	file_name = name[/#{str1}(.*?)#{str2}/m, 1]

	f = File.open("empresas/#{file_name}_files/Cnpjreva_Comprovante.htm")
	documento = Nokogiri::HTML(f)

	puts "==============================="
	puts "index: " + index.to_s

	begin

		cnpj 					= documento.css('table')[4].css('b')[0].text.gsub(/\./, "")
		nome_empresa 	= documento.css('table')[5].css('b').text	
		rua 					= documento.css('table')[10].css('b')[0].text.capitalize!
		numero 				= documento.css('table')[10].css('b')[1].text
		bairro 				= documento.css('table')[11].css('b')[1].text
		cidade 				= documento.css('table')[11].css('b')[2].text
		estado 				= documento.css('table')[11].css('b')[3].text



		# CEP
		cep = documento.css('table')[11].css('b')[0].text.gsub(/\./, "")
		
		# COMPLEMENTO
		complemento = documento.css('table')[10].css('b')[2].text
		if  complemento.to_s.strip.length == 0
			complemento = ""
		else
			complemento.strip!
			complemento.capitalize!
		end

		puts "#{cnpj}"

		 string_final = "CNPJ: " + cnpj + "\n\n"
		 string_final += nome_empresa + "\n"
		 string_final += rua + ", Nº " + numero + ", " + complemento.split.join(" ") + ", " + bairro  + "\n"
		 string_final +=  cidade + "/"+ estado + "      CEP: " + cep  + "\n\n\n\n\n"

		 File.open("out.txt", 'a') {|f| f.write(string_final) }
	rescue

		msg_erro = "erro no CNPJ: " + cnpj.to_s + "\n\n\n\n\n"

		File.open("falhas.txt", 'a') {|f| f.write(string_final) }
	end



# Estrutura tabela:

# documento.css('table')[4].css('b')[0].text       CNPJ

# documento.css('table')[5].css('b').text   		NOME EMPRESA

# documento.css('table')[10].css('b')[0].text   Rua
# documento.css('table')[10].css('b')[1].text  NUMERO
# documento.css('table')[10].css('b')[2].text COMPLEMENTO
# documento.css('table')[11].css('b')[1].text BAIRRO

# documento.css('table')[11].css('b')[2].text CIDADE
# documento.css('table')[11].css('b')[1].text ESTADO
# documento.css('table')[11].css('b')[3].text CEP


end
