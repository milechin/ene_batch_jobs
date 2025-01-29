import os

job_id = os.environ.get("JOB_ID")
job_name = os.environ.get("JOB_NAME")
nslots = os.environ.get("NSLOTS")
hostname = os.environ.get("HOSTNAME")
sge_task_id = os.environ.get("SGE_TASK_ID")
tmpdir = os.environ.get("TMPDIR")


print("\n\nEnvironment variables inside python script:")
print(f"JOB_ID: {job_id}")
print(f"JOB_NAME: {job_name}")
print(f"NSLOTS: {nslots}")
print(f"HOSTNAME: {hostname}")
print(f"SGE_TASK_ID: {sge_task_id}")
print(f"TMPDIR: {tmpdir}")
