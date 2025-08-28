echo "⚠️ Warning: This action will delete the current quickshell config!"
read -p "Are you sure you want to continue? (y/N): " confirm

case "$confirm" in
    [yY][eE][sS]|[yY])
        echo "Deleting quickshell config..."
        # put your deletion command here, e.g.:
        # rm -rf ~/.config/quickshell
	rm -rf ~/.config/quickshell/*
	cp -r ./modules ~/.config/quickshell
	cp ./shell.qml ~/.config/quickshell/
	echo "Quickshell config successfully copied to ~/.config/quickshell"
        ;;
    *)
        echo "Operation cancelled."
        exit 1
        ;;
esac
