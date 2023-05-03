FROM docker.io/gentoo/stage3:latest

ENV NAME=gentoo-toolbox VERSION=rolling
LABEL com.github.containers.toolbox="true" \
      com.github.debarshiray.toolbox="true" \
      name="$NAME" \
      version="$VERSION" \
      usage="This image is meant to be used with the toolbox command" \
      summary="Base image for creating Gentoo toolbox containers" \
      maintainer="esi <git@esibun.net>"

# Disable emerge sandboxing features incompatible with podman
RUN sed - '/FFLAGS/a \\n# Required for emerge to work correctly in toolbox\nFEATURES="-ipc-sandbox -network-sandbox -pid-sandbox"' /etc/portage/make.conf

# Install required dependencies to run `toolbox`
RUN emerge-webrsync
RUN emerge app-admin/sudo dev-vcs/git

# Required steps otherwise `toolbox` fails to start the container:
# 1. machine-id must be present in the base image
# 2. $(whoami) must be in the sudoer list without password
# 3. /media must be present (toolbox tries to remove the folder and create a symlink)
RUN touch /etc/machine-id && \
  mkdir -p /etc/sudoers.d && \
  echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/toolbox && \
  mkdir -p /media

# Toolbox doesn't set correctly $PROMPT_COMMAND
# This step unset the variable if it's composed only by white spaces
RUN sed -i '/PS1/a \\n# Clean \$PROMPT_COMMAND not correctly set by Toolbox\n\[\[ \-z \"\$\{PROMPT_COMMAND// \}\" \]\] && unset PROMPT_COMMAND' /etc/bash/bashrc

CMD /bin/bash
