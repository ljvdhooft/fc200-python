import time
import subprocess
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler


class ReloadHandler(FileSystemEventHandler):
    def on_modified(self, event):
        if event.src_path.endswith(".py"):
            print(f"File {event.src_path} changed. Reloading Ableton...")
            # Run the AppleScript
            subprocess.run(["osascript", "reload-ableton.scpt"])


if __name__ == "__main__":
    path = "src/"  # Point this to your Remote Script folder
    event_handler = ReloadHandler()
    observer = Observer()
    observer.schedule(event_handler, path, recursive=False)
    observer.start()
    print("Watching for changes... Press Ctrl+C to stop.")
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
    observer.join()
