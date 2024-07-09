// Opportunity Protocol JobManagement smart contract
// Proof of Concept
// Application Layer

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_caller_address

// Job status enum
const JOB_STATUS_CREATED = 0
const JOB_STATUS_ACCEPTED = 1
const JOB_STATUS_COMPLETED = 2
const JOB_STATUS_DISPUTED = 3
const JOB_STATUS_SETTLED = 4

// Job struct
struct Job:
    member employer : felt
    member worker : felt
    member payment : Uint256
    member job_description_hash : felt
    member status : felt
    member created_at : felt
    member completed_at : felt
end

// Storage variables
@storage_var
func jobs(job_id : felt) -> (job : Job):
end

@storage_var
func job_counter() -> (count : felt):
end

// Events
@event
func JobCreated(job_id : felt, employer : felt, payment : Uint256, job_description_hash : felt):
end

@event
func JobAccepted(job_id : felt, worker : felt):
end

@event
func JobCompleted(job_id : felt):
end

@event
func DisputeRaised(job_id : felt, raised_by : felt):
end

@event
func DisputeSettled(job_id : felt, winner : felt):
end

// Functions
@external
func create{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    job_description_hash : felt, payment : Uint256
) -> (job_id : felt):
    let (caller) = get_caller_address()
    let (current_job_id) = job_counter.read()
    let new_job_id = current_job_id + 1

    let new_job = Job(
        employer=caller,
        worker=0,
        payment=payment,
        job_description_hash=job_description_hash,
        status=JOB_STATUS_CREATED,
        created_at=0,  // TODO: Implement timestamp
        completed_at=0
    )

    jobs.write(new_job_id, new_job)
    job_counter.write(new_job_id)

    JobCreated.emit(new_job_id, caller, payment, job_description_hash)

    return (new_job_id)
end

@external
func accept{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    job_id : felt
) -> ():
    let (caller) = get_caller_address()
    let (job) = jobs.read(job_id)

    assert job.status = JOB_STATUS_CREATED
    
    let updated_job = Job(
        employer=job.employer,
        worker=caller,
        payment=job.payment,
        job_description_hash=job.job_description_hash,
        status=JOB_STATUS_ACCEPTED,
        created_at=job.created_at,
        completed_at=0
    )

    jobs.write(job_id, updated_job)

    JobAccepted.emit(job_id, caller)

    return ()
end

@external
func complete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    job_id : felt
) -> ():
    let (caller) = get_caller_address()
    let (job) = jobs.read(job_id)

    assert job.employer = caller
    assert job.status = JOB_STATUS_ACCEPTED

    let updated_job = Job(
        employer=job.employer,
        worker=job.worker,
        payment=job.payment,
        job_description_hash=job.job_description_hash,
        status=JOB_STATUS_COMPLETED,
        created_at=job.created_at,
        completed_at=0  // TODO: Implement timestamp
    )

    jobs.write(job_id, updated_job)

    JobCompleted.emit(job_id)

    // TODO: Implement payment transfer

    return ()
end

@external
func dispute{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    job_id : felt
) -> ():
    let (caller) = get_caller_address()
    let (job) = jobs.read(job_id)

    assert (caller = job.employer) or (caller = job.worker)
    assert job.status = JOB_STATUS_ACCEPTED

    let updated_job = Job(
        employer=job.employer,
        worker=job.worker,
        payment=job.payment,
        job_description_hash=job.job_description_hash,
        status=JOB_STATUS_DISPUTED,
        created_at=job.created_at,
        completed_at=job.completed_at
    )

    jobs.write(job_id, updated_job)

    DisputeRaised.emit(job_id, caller)

    return ()
end

@external
func settle{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    job_id : felt, winner : felt
) -> ():
    // TODO: Implement proper authorization for dispute settlement
    let (job) = jobs.read(job_id)

    assert job.status = JOB_STATUS_DISPUTED
    assert (winner = job.employer) or (winner = job.worker)

    let updated_job = Job(
        employer=job.employer,
        worker=job.worker,
        payment=job.payment,
        job_description_hash=job.job_description_hash,
        status=JOB_STATUS_SETTLED,
        created_at=job.created_at,
        completed_at=0  // TODO: Implement timestamp
    )

    jobs.write(job_id, updated_job)

    DisputeSettled.emit(job_id, winner)

    // TODO: Implement payment transfer based on settlement

    return ()
end