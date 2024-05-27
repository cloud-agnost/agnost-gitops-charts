{{- /*
Generate a random base64-safe alphanumeric string of a specified length.
*/ -}}
{{- define "randAlphaNumBase64Safe" -}}
{{- $length := . -}}
{{- $alphabet := "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/" -}}
{{- $alphabetLength := len $alphabet -}}
{{- $result := "" -}}
{{- range $i := until $length -}}
{{- $result = printf "%s%c" $result (index $alphabet (randInt 0 $alphabetLength)) -}}
{{- end -}}
{{- $result -}}
{{- end -}}