#!/usr/bin/env bash
# ==============================================================================
# url_encode_password.sh
# Faz o percent-encoding de uma senha para uso em URLs do SQLAlchemy / Superset
# Sem dependências externas — funciona em qualquer Debian limpo
# ==============================================================================

set -euo pipefail

# ------------------------------------------------------------------------------
# Função de encode puro em bash
# Caracteres não reservados (RFC 3986) passam direto; todos os outros viram %XX
# ------------------------------------------------------------------------------
url_encode() {
  local string="$1"
  local encoded=""
  local i char hex

  for (( i=0; i<${#string}; i++ )); do
    char="${string:$i:1}"
    case "$char" in
      [a-zA-Z0-9._~-]) encoded+="$char" ;;
      *) printf -v hex "%%%02X" "'$char"
         encoded+="$hex" ;;
    esac
  done

  echo "$encoded"
}

# ------------------------------------------------------------------------------
# Uso / Help
# ------------------------------------------------------------------------------
usage() {
  cat <<EOF

  USO:
    $0 "<senha>"
    $0 --help

  DESCRIÇÃO:
    Recebe uma senha como argumento e retorna ela com percent-encoding,
    pronta para ser usada em uma SQLAlchemy URI (ex: no Apache Superset).
    Não depende de Python, Node ou qualquer pacote externo.

  EXEMPLOS:
    $0 'minha@senha#123'
    → minha%40senha%23123

    $0 'abc/def:ghi@jkl'
    → abc%2Fdef%3Aghi%40jkl

  CARACTERES MAIS COMUNS QUE SÃO ESCAPADOS:
    @  →  %40      /  →  %2F
    #  →  %23      %  →  %25
    :  →  %3A      +  →  %2B
    espaço → %20

  COMO USAR NO SUPERSET:
    Substitua a senha na URI pelo valor retornado. Exemplo:

      Antes:  postgresql://user:minha@senha#123@host:5432/db
      Depois: postgresql://user:minha%40senha%23123@host:5432/db

  DEPENDÊNCIAS:
    Apenas bash 4+ — nativo em qualquer Debian/Ubuntu.

EOF
  exit 0
}

# ------------------------------------------------------------------------------
# Sem argumentos → exibe ajuda
# ------------------------------------------------------------------------------
if [[ $# -eq 0 ]]; then
  echo ""
  echo "  ⚠️  Nenhuma senha fornecida."
  usage
fi

# ------------------------------------------------------------------------------
# Flag --help
# ------------------------------------------------------------------------------
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
  usage
fi

# ------------------------------------------------------------------------------
# Encode e saída
# ------------------------------------------------------------------------------
PASSWORD="$1"
ENCODED=$(url_encode "$PASSWORD")

echo ""
echo "  Senha original : $PASSWORD"
echo "  Senha encoded  : $ENCODED"
echo ""
