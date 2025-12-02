FROM grafana/grafana:latest

USER root

# Copy your logo from your PC into the container's temp folder
COPY assets/logo.png /tmp/logo.png
COPY assets/logo.svg /tmp/logo.svg
COPY assets/logo-black.svg /tmp/logo-black.svg
COPY assets/logo-white.svg /tmp/logo-white.svg

# Logo
RUN cp /tmp/logo.svg /usr/share/grafana/public/img/grafana_icon.svg && \
    cp /tmp/logo.svg /usr/share/grafana/public/img/grafana_com_auth_icon.svg && \
    cp /tmp/logo-black.svg /usr/share/grafana/public/img/grafana_mask_icon.svg && \
    cp /tmp/logo-white.svg /usr/share/grafana/public/img/grafana_mask_icon_white.svg

# Favicon
RUN cp /tmp/logo.png /usr/share/grafana/public/img/fav32.png && \
    cp /tmp/logo.png /usr/share/grafana/public/img/apple-touch-icon.png

# searches for any file named "grafana_icon.SOMETHING.svg" and overwrites it.
RUN find /usr/share/grafana/public/build/static/img/ -name "grafana_icon.*.svg" -exec cp /tmp/logo.svg {} \;

# Switch back to the default Grafana user so it runs safely
USER grafana
