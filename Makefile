.PHONY: verify clean

# Default: verify all tasks
verify:
ifdef TASK
	@bash scripts/verify_task.sh $(TASK)
else
	@bash scripts/verify_all.sh tasks
endif

# Clean up Docker images created by verification
clean:
	@echo "Cleaning debug-lab Docker images..."
	@docker images --format '{{.Repository}}:{{.Tag}}' | grep '^debug-lab-' | xargs -r docker rmi -f 2>/dev/null || true
	@echo "Done."

# Scaffold a new task
new-task:
ifndef NAME
	$(error Usage: make new-task NAME=<task-name>)
endif
	@bash scripts/new_task.sh $(NAME)
