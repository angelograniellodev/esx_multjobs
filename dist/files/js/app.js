const audioPath = 'https://r2.fivemanage.com/NLvSDQrlSIhggC9nZDqnE/click.ogg';
const audio = new Audio(audioPath);

window.addEventListener('message', function(event) {
    if (event.data.type === 'showJobs') {
        const jobContainer = document.querySelector('.container');
        const jobList = document.querySelector('.job-list');
        jobContainer.style.display = 'block';
        jobList.innerHTML = '';
        event.data.jobs.forEach(job => {
            const li = document.createElement('li');
            li.innerHTML = `${job.label} <div class="icons"><i class="fas fa-check" onclick="selectJob('${job.value}', '${job.grade}')"></i><i class="fas fa-trash-alt" onclick="deleteJob('${job.value}', '${job.grade}')"></i></div>`;
            jobList.appendChild(li);
        });
    }
});

document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        const jobContainer = document.querySelector('.container');
        jobContainer.style.display = 'none';

        fetch(`https://${GetParentResourceName()}/close`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8'
            },
            body: JSON.stringify({})
        }).then(resp => resp.json()).then(resp => {
            console.log(resp);
        });
    }
});

function selectJob(job, grade) {
    audio.play();
    const jobContainer = document.querySelector('.container');
    jobContainer.style.display = 'none';
    console.log(`Selected Job: ${job}, Grade: ${grade}`);
    fetch(`https://${GetParentResourceName()}/selectjob`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8'
        },
        body: JSON.stringify({ job: job, grade: grade })
    }).then(resp => resp.json()).then(resp => {
        console.log(resp);
    });
}

function deleteJob(job, grade) {
    audio.play();
    const jobContainer = document.querySelector('.container');
    jobContainer.style.display = 'none';
    console.log(`Deleted Job: ${job}, Grade: ${grade}`);
    fetch(`https://${GetParentResourceName()}/deletejob`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8'
        },
        body: JSON.stringify({ job: job, grade: grade })
    }).then(resp => resp.json()).then(resp => {
        console.log(resp);
    });
}
