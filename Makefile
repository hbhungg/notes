PREFIX ?= /usr/local
BASH_COMPLETION_DIR ?= $(shell pkg-config --silence-errors --variable=completionsdir bash-completion)
USERDIR ?= $(HOME)

# The @ symbols make the output silent.

install:
	@if [ $(BASH_COMPLETION_DIR) ]; then \
		cp notes.bash_completion "$(BASH_COMPLETION_DIR)/notes"; \
	else \
		printf \
"Bash completion was not installed, because the directory was not found. \
If you have bash completion installed, follow the README \
(https://github.com/pimterry/notes#installing-bash-completion) \
to manually install it.\n\n"; \
	fi # Small test for bash completion support

	@install -m755 -d $(PREFIX)/bin/
	@install -m755 notes $(PREFIX)/bin/
	@install -d $(PREFIX)/share/man/man1/
	@install notes.1 $(PREFIX)/share/man/man1/

	@mandb 1>/dev/null 2>&1 || true # Fail silently if we don't have a mandb

	@printf "Notes has been installed to $(PREFIX)/bin/notes.\n"

	@if [ ! -f $(USERDIR)/.config/notes/config ]; then \
		install -m777 -d $(USERDIR)/.config/notes/; \
		install -m777 config $(USERDIR)/.config/notes/; \
		printf \
"A configuration file has also been created at $(USERDIR)/.config/notes/config, \
which you can edit if you'd like to change the default settings.\n"; \
	fi # install default config file if non present

	@printf \
"\nGet started now by running 'notes new my-note' \
or you can run 'notes help' for more info.\n"; \

uninstall:
	rm -f $(PREFIX)/bin/notes
	rm -f $(PREFIX)/share/man/man1/notes.1
	rm -f $(BASH_COMPLETION_DIR)/notes
	rm -f $(USERDIR)/.config/notes/config.example

	@printf "\nNotes has now been uninstalled.\n"

install-bash-auto-completion:
	cp notes.bash_completion /opt/homebrew/share/bash-completion/completions/notes