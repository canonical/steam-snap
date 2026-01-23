mkdir -p /home/$USER/snap/steam/common/.local/share/Steam/steamapps
sudo mount --bind /home/$USER/.local/share/Steam/steamapps/ /home/$USER/snap/steam/common/.local/share/Steam/steamapps
sudo mount --bind ~/.steam/steam/compatibilitytools.d/ ~/snap/steam/common/.steam/steam/compatibilitytools.d/
