#!/bin/bash

trap ctrl_c INT

function ctrl_c(){
	echo -e "\n\n[*] PARANDO MÁQUINAS...\n[*] MANDANDO TRABAJADORES A SUS CASAS...\n[*] LA QUE HAS LIADO...\n"
	exit 0
}

echo -e "\n\n[*] HACIENDO COSAS MALOSAS\n[*] NIÑOS NO MIRÉIS\n\n"
echo "ICAgICAgIC4tIi0uICAgICAgICAgICAgLi0iLS4gICAgICAgICAgICAuLSItLiAgICAgICAgICAgLi0iLS4KICAgICBfL18tLi1fXF8gICAgICAgIF8vLi0uLS5cXyAgICAgICAgXy8uLS4tLlxfICAgICAgIF8vLi0uLS5cXwogICAgLyBfX30ge19fIFwgICAgICAvfCggbyBvICl8XCAgICAgICggKCBvIG8gKSApICAgICAoICggbyBvICkgKQogICAvIC8vICAiICBcXCBcICAgIHwgLy8gICIgIFxcIHwgICAgICB8LyAgIiAgXHwgICAgICAgfC8gICIgIFx8CiAgLyAvIFwnLS0tJy8gXCBcICAvIC8gXCctLS0nLyBcIFwgICAgICBcJy9eXCcvICAgICAgICAgXCAuLS4gLwogIFwgXF8vYCIiImBcXy8gLyAgXCBcXy9gIiIiYFxfLyAvICAgICAgL2BcIC9gXCAgICAgICAgIC9gIiIiYFwKICAgXCAgICAgICAgICAgLyAgICBcICAgICAgICAgICAvICAgICAgLyAgL3xcICBcICAgICAgIC8gICAgICAgXAo=" | base64 -d

echo "Inicia sesión en tu Moodle y copia aquí la URL"

read urlbruta

echo "Introduce tu cookie de sesion de la siguiente forma \"MoodleSession=tucookie\""

read cookie

urlresources=( $(echo $urlbruta | awk '{gsub(/view/,"resources");print}') )
echo "La URL de la cual vamos a sacar los recursos es $urlresources"


sacarpdf (){
	echo "\nEstamos buscando pdfs en la raíz\n"
	pdf=( $(curl -s --cookie $1 $2 | grep -Eoi '<a [^>]+>'| grep -Eo 'href="[^\"]+"' | grep -Eo '(http|https)://[^\"]+pdf') )
        longitudpdf=${#pdf[@]}
        let longitudarraypdf=$longitudpdf-1
                for a in $(seq 0 $longitudarraypdf); do
                        curl -s --cookie $1 -O ${pdf[$a]}
                done
}

pdfenurl () {
	echo "\nEstamos buscando pdfs en las urls internas\n"
	url=( $(curl -s --cookie $1 $2 | grep -Eoi '<a [^>]+>'| grep -Eo 'href="[^\"]+"' | grep -Eo '(http|https)://[^\"]+' | grep id | grep resource\/) )
	longitudurl=${#url[@]}
	let longitudarrayurl=$longitudurl-1
	for i in $(seq 0 $longitudarrayurl); do
		pdf=( $(curl -s --cookie $1 ${url[$i]} | grep -Eoi '<a [^>]+>'| grep -Eo 'href="[^\"]+"' | grep -Eo '(http|https)://[^\"]+' | grep pdf) )
		longitudpdf=${#pdf[@]}
		let longitudarraypdf=$longitudpdf-1
			for a in $(seq 0 $longitudarraypdf); do
				nombretitulo=$(curl -s --cookie $1 ${url[$i]} | grep \<title\> | sed -e 's/.*title>\(.*\)<\/title.*/\1/')
				extensionarchivo=".pdf"
				nombrearchivo=$nombretitulo$extensionarchivo
				curl -s --cookie $1 ${pdf[$a]} --output "$nombrearchivo"
			done
	done
}

pdfencarpeta () {
	echo "\nEstamos buscando pdfs en carpetas concretas\n"
	url=( $(curl -s --cookie $1 $2 | grep -Eoi '<a [^>]+>'| grep -Eo 'href="[^\"]+"' | grep -Eo '(http|https)://[^\"]+' | grep folder) )
	longitudurl=${#url[@]}
	let longitudarrayurl=$longitudurl-1
	for i in $(seq 0 $longitudarrayurl); do
	        pdf=( $(curl -s --cookie $1 ${url[$i]} | grep -Eoi '<a [^>]+>'| grep -Eo 'href="[^\"]+"' | grep -Eo '(http|https)://[^\"]+pdf') )
	        longitudpdf=${#pdf[@]}
	        let longitudarraypdf=$longitudpdf-1
	                for a in $(seq 0 $longitudarraypdf); do
	                        curl -s --cookie $1 -O ${pdf[$a]}
	                done
	done
}

sacarpdf "$cookie $urlresources"
pdfenurl "$cookie $urlresources"
pdfencarpeta "$cookie $urlresources"

echo -e "\n\n[*] SE ACABÓ, TODO EL MUNDO A DORMIR[*]\n\n"
echo "ICAgICAgIC4tIi0uICAgICAgICAgICAgLi0iLS4gICAgICAgICAgICAuLSItLiAgICAgICAgICAgLi0iLS4KICAgICBfL18tLi1fXF8gICAgICAgIF8vLi0uLS5cXyAgICAgICAgXy8uLS4tLlxfICAgICAgIF8vLi0uLS5cXwogICAgLyBfX30ge19fIFwgICAgICAvfCggbyBvICl8XCAgICAgICggKCBvIG8gKSApICAgICAoICggbyBvICkgKQogICAvIC8vICAiICBcXCBcICAgIHwgLy8gICIgIFxcIHwgICAgICB8LyAgIiAgXHwgICAgICAgfC8gICIgIFx8CiAgLyAvIFwnLS0tJy8gXCBcICAvIC8gXCctLS0nLyBcIFwgICAgICBcJy9eXCcvICAgICAgICAgXCAuLS4gLwogIFwgXF8vYCIiImBcXy8gLyAgXCBcXy9gIiIiYFxfLyAvICAgICAgL2BcIC9gXCAgICAgICAgIC9gIiIiYFwKICAgXCAgICAgICAgICAgLyAgICBcICAgICAgICAgICAvICAgICAgLyAgL3xcICBcICAgICAgIC8gICAgICAgXAo=" | base64 -d

