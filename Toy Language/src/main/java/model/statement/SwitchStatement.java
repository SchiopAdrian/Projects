package model.statement;

import exceptions.InterpreterException;
import model.expression.IExpression;
import model.expression.RelationalExpression;
import model.programState.ProgramState;
import model.type.IntType;
import model.type.Type;
import model.utils.MyIDictionary;
import model.utils.MyIHeap;
import model.utils.MyIStack;
import model.value.Value;

public class SwitchStatement implements IStatement{
    IExpression compareExpression;
    IExpression firstCase;
    IExpression secondCase;
    IStatement firstCaseStmt;
    IStatement secondCaseStmt;
    IStatement defaultStmt;
    public SwitchStatement(IExpression compareExpression, IExpression firstCase, IStatement firstCaseStmt,IExpression secondCase, IStatement secondCaseStmt,IStatement defaultStmt){
        this.compareExpression = compareExpression;
        this.firstCase = firstCase;
        this.secondCase = secondCase;
        this.firstCaseStmt = firstCaseStmt;
        this.secondCaseStmt = secondCaseStmt;
        this.defaultStmt = defaultStmt;
    }

    @Override
    public ProgramState execute(ProgramState state) throws InterpreterException {
        MyIStack stack = state.getExeStack();
        MyIDictionary<String, Value> symTable = state.getSymTable();
        MyIHeap heap = state.getHeap();
        IStatement finalStmt = new IfStatement(new RelationalExpression("==", compareExpression, firstCase), firstCaseStmt, new IfStatement(new RelationalExpression("==", compareExpression, secondCase), secondCaseStmt, defaultStmt));
        stack.push(finalStmt);
        return null;
    }

    @Override
    public MyIDictionary<String, Type> typeCheck(MyIDictionary<String, Type> typeEnv) throws InterpreterException {
        Type type1 = compareExpression.typeCheck(typeEnv);
        Type type2 = firstCase.typeCheck(typeEnv);
        Type type3 = firstCase.typeCheck(typeEnv);
        if(type1.equals(new IntType())&& type2.equals(new IntType()) && type3.equals(new IntType())){
            firstCaseStmt.typeCheck(typeEnv.deepCopy());
            secondCaseStmt.typeCheck(typeEnv.deepCopy());
            defaultStmt.typeCheck(typeEnv.deepCopy());
            return typeEnv;
        }else throw new InterpreterException("At least 1 of the 3 expression is not of type int");
    }

    @Override
    public IStatement deepCopy() {
        return new SwitchStatement(compareExpression,firstCase,firstCaseStmt,secondCase,secondCaseStmt, defaultStmt);
    }
    @Override
    public String toString(){
        return String.format("switch(%s) (case %s: %s) (case %s: %s) (default:%s)", compareExpression.toString(),firstCase.toString(),
                firstCaseStmt.toString(),secondCase.toString(),secondCaseStmt.toString(),defaultStmt.toString());
    }
}
