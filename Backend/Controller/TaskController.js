const {Tasks} =require('../Models/SequlizerModel')



const getAllTasksOfUser = async(req,res) =>{
    try{
    
    const userId = req.user.id;

    const tasks = await Tasks.findAll({
        where:{
            UserId:userId
        }
    })
    if(!tasks){
        return res.status(404).send('No tasks assigned to the user');
    }
    console.log(tasks);
    return res.status(200).json(tasks);
    
    }catch(err){
        console.error('Unexprected error at getting tasks')
        return res.status(500).send('Unexprected error at getting tasks')
    }
}



const createTask = async(req,res)=>{
    try{

        const {id,title,description,to,from} = req.body;
        const userid = req.user.id;
        const newTask = {id:id, title:title,description:description, UserId:userid, to:to, from:from};  
        
        const task = await Tasks.create(newTask);
        
        return res.status(200).send({task: task, message:`Task added succesfully`});
        
    }catch(err){
        return res.status(500).send({err, message: 'Unexpected error while creating a task'});
    }
}

const updateTask = async(req,res) =>{
    try{
        const id = req.params.id
        const {title, description, to, from} = req.body;
        
        const updateTask = {title:title, description:description, to:to, from:from};
        const task = await Tasks.findByPk(id);
        
        if(!task){
            res.status(404).send({task:task, message: `Task with id ${id} not found`});
        }
        await task.update(updateTask);
        
        return res.status(200).send({task, message:'Task updated succesfully'});
    }catch(err){
        res.status(400).send({err,message:'Unexpected error at update task'});
    }
}

const getOneTask = async (req,res) =>{
    try{
        const id = req.params.id
        const task  = await Tasks.findByPk(id);
        if(!task){
            return res.status(404).send({task:task, message: `Task with id ${id} not found`});
        }
        return res.status(200).send(task);
    }catch(err){
        res.status(400).send({err,message:'Unexpected error at getting one task'});
    }
}


const deleteTask = async(req,res) =>{
    try{
        const id = req.params.id
        const result = await Tasks.findByPk(id);
        if(!result){
            return res.status(404).send({message: `Task with id ${id} not found`});
        }
        await result.destroy();
        return res.status(200).send({message: 'Task deleted succesfully'});
    }catch(err){
        return res.status(400).send({err,message:'Unexpected error at deleting a task'})
    }
}
module.exports = {getAllTasksOfUser,createTask,updateTask, getOneTask, deleteTask};
