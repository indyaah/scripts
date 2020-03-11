ghget () {
	USER=$(echo $@ | tr "/" " " | awk '{print $1}')
	REPO=$(echo $@ | tr "/" " " | awk '{print $2}')
	mcd "$HOME/.src/github.com/$USER"
	touch "$HOME/.src/github.com/$@"
	cd "$HOME/.src/"
	BRANCH_NAME=$(date -u +"%Y-%m-%dT%H-%M-%SZ")
	git co -b "$BRANCH_NAME"
	git add "$HOME/.src/github.com/$@"
	git commit -m "Added https://github.com/$@"
	git co master
	git merge $BRANCH_NAME
	git push
	git branch -D "$BRANCH_NAME"
	mcd "$HOME/src/github.com/$USER" && hub clone $@ && cd $REPO
}

mcd () {
	mkdir -p -p "$@" && cd "$@"
}

til() {
 	DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
 	CWD=$(pwd)
 	cd ~/src/github.com/indyaah/til
	BRANCH_NAME=$(date -u +"%Y-%m-%dT%H-%M-%SZ")

	LINK="$1"
	TITLE="$2"
	NOTES="$3"
	CATEGORY="$4"
	FILE="$5"

	git co master
	git pull --rebase
	git co -b "$BRANCH_NAME"

	[[ ! -z "$CATEGORY" ]] && [[ ! -z "$FILE" ]] && mkdir -p "./uploads/$CATEGORY" && cp "$HOME/Downloads/$FILE" "./uploads/$CATEGORY/" && git add "./uploads/$CATEGORY/$FILE" && NOTES="$NOTES<br/><br/>[ARCHIVED ARTICLE](../master/uploads/$CATEGORY/$FILE)"

	gsed -i "8i|$DATE|$LINK|$TITLE|$NOTES|" README.md
	git add README.md
	git commit -m "Added $1"
	git co master
	git merge $BRANCH_NAME
	git push
	git branch -D "$BRANCH_NAME"
	cd $CWD
}
