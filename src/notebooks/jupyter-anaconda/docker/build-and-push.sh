if  [ -z "$1" ]; then
  echo ""
  echo "Usage:   .\build-and-push.sh <VERSION>"
  echo ""
  echo "Example: .\build-and-push.sh 0.0.1"
  echo ""
  exit 0
fi

VERSION=$1

docker build -t sspaeti/jupyter-anaconda:py3.7-spark3-$VERSION .
docker push sspaeti/jupyter-anaconda:py3.7-spark3-$VERSION