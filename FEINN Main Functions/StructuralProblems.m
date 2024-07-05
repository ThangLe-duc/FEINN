function [problem,nn] = StructuralProblems(F,valid,nn,problem)

switch F              
    case '10bars'
        if strcmp(nn.ObjType,'physicLoss')
%         DatTrain = load('.\Training Data\10 Bars\Dis_10bars100_Train.mat');
        DatTrain = load('.\Training Data\10 Bars\Dis_10bars1000_Train.mat');
        % DatTrain = load('.\Training Data\10 Bars\Dis_10bars10000_Train.mat');

%         DatTrain = load('.\Training Data\10 Bars\Dis_10bars1000_Train_SystemNoise_01.mat');
        % DatTrain = load('.\Training Data\10 Bars\Dis_10bars1000_Train_SystemNoise_02.mat');
%         DatTrain = load('.\Training Data\10 Bars\Dis_10bars1000_Train_SystemNoise_03.mat');
%         DatTrain = load('.\Training Data\10 Bars\Dis_10bars1000_Train_SystemNoise_04.mat');
%         DatTrain = load('.\Training Data\10 Bars\Dis_10bars1000_Train_SystemNoise_05.mat');

%         DatTrain = load('.\Training Data\10 Bars\Dis_10bars10000_Train_SystemNoise_02.mat');
        DatTest = load('.\Training Data\10 Bars\Dis_10bars10000_Test.mat');
        DatValid = load('.\Training Data\10 Bars\Dis_10bars_Valid.mat');
        else
        % DatTrain = load('.\Training Data\10 Bars_DDNN\Dis_10bars100_Train.mat');
        DatTrain = load('.\Training Data\10 Bars_DDNN\Dis_10bars1000_Train.mat');
%         DatTrain = load('.\Training Data\10 Bars_DDNN\Dis_10bars10000_Train.mat');

%         DatTrain = load('.\Training Data\10 Bars_DDNN\Dis_10bars1000_Train_SystemNoise_01.mat');
%         DatTrain = load('.\Training Data\10 Bars_DDNN\Dis_10bars1000_Train_SystemNoise_02.mat');
%         DatTrain = load('.\Training Data\10 Bars_DDNN\Dis_10bars1000_Train_SystemNoise_03.mat');
%         DatTrain = load('.\Training Data\10 Bars_DDNN\Dis_10bars1000_Train_SystemNoise_04.mat');
%         DatTrain = load('.\Training Data\10 Bars_DDNN\Dis_10bars1000_Train_SystemNoise_05.mat');

%         DatTrain = load('.\Training Data\10 Bars_DDNN\Dis_10bars10000_Train_SystemNoise_02.mat');
        DatTest = load('.\Training Data\10 Bars_DDNN\Dis_10bars10000_Test.mat');
        DatValid = load('.\Training Data\10 Bars_DDNN\Dis_10bars_Valid.mat');
        end
        
        Ino = problem.ANNStruc(1);
        Ono = problem.ANNStruc(size(problem.ANNStruc,2));
        XTrain = DatTrain.DisAll10bars_Train(:,1:Ino);
        YTrain = DatTrain.DisAll10bars_Train(:,Ino+1:Ino+Ono);
        XTest = DatTest.DisAll10bars_Test(:,1:Ino);
        YTest = DatTest.DisAll10bars_Test(:,Ino+1:Ino+Ono);
        XValid = DatValid.DisAll10bars_Valid(:,1:Ino);
        YValid = DatValid.DisAll10bars_Valid(:,Ino+1:Ino+Ono);
        problem.YTestTrue = YTest;
        problem.YValidTrue = YValid;
        problem.XScale = 33.5;
        problem.YScale = 1;
        
        XTrain = XTrain./problem.XScale;
        YTrain = YTrain./problem.YScale;
        XTest = XTest./problem.XScale;
        YTest = YTest./problem.YScale;
        XValid = XValid./problem.XScale;
        YValid = YValid./problem.YScale;
        
        [nW, nB, nn] = DNN_Structure(problem.ANNStruc, nn);
        problem.nW = nW;
        problem.nB = nB;
        problem.dim = nW + nB;
%         problem.psY = psY;
        % Separate to training and test data
        I2 = XTrain;
        T = YTrain;
        I2Test = XTest;
        TTest = YTest;
        I2Valid = XValid;
        TValid = YValid;
        
        I2Train = I2;
        TTrain = T;
        problem.xTrain = I2Train';
        problem.yTrain = TTrain';
        
        problem.xTest = I2Test';
        problem.yTest = TTest';
        
        problem.xValid = I2Valid';
        problem.yValid = TValid';
        
        if strcmp(nn.ObjType,'physicLoss')
            problem.fobj = @DPINN_PhysicsLoss_Comb;
        else
            problem.fobj = @DNN_Loss;
        end
        
    case '72bars'
        if strcmp(nn.ObjType,'physicLoss')
        DatTrain = load('.\Training Data\72 Bars_Force Input\Disp_72bars1000_Train.mat');
%         DatTrain = load('.\Training Data\72 Bars_Force Input\Disp_72bars1000_Train_SystemNoise_02.mat');
%         DatTrain = load('.\Training Data\72 Bars_Force Input\Disp_72bars10000_Train.mat');
        % DatTrain = load('.\Training Data\72 Bars_Force Input\Disp_72bars10000_Train_SystemNoise_02.mat');
        DatTest = load('.\Training Data\72 Bars_Force Input\Disp_72bars10000_Test.mat');
        DatValid = load('.\Training Data\72 Bars_Force Input\Disp_72bars_Valid.mat');
        else
        % DatTrain = load('.\Training Data\72 Bars_DDNN\Disp_72bars1000_Train.mat');
%         DatTrain = load('.\Training Data\72 Bars_DDNN\Disp_72bars10000_Train.mat');    
        DatTrain = load('.\Training Data\72 Bars_DDNN\Disp_72bars1000_Train_SystemNoise_02.mat');
        % DatTrain = load('.\Training Data\72 Bars_DDNN\Disp_72bars10000_Train_SystemNoise_02.mat');
        DatTest = load('.\Training Data\72 Bars_DDNN\Disp_72bars10000_Test.mat');
        DatValid = load('.\Training Data\72 Bars_DDNN\Disp_72bars_Valid.mat');
        end

        Ino = problem.ANNStruc(1);
        Ono = problem.ANNStruc(size(problem.ANNStruc,2));
        XTrain = DatTrain.DispAll_Train(:,1:Ino);
        YTrain = DatTrain.DispAll_Train(:,Ino+problem.nDOFelim+1:Ino+problem.nDOFelim+Ono);
        XTest = DatTest.DispAll_Test(:,1:Ino);
        YTest = DatTest.DispAll_Test(:,Ino+problem.nDOFelim+1:Ino+problem.nDOFelim+Ono);
        XValid = DatValid.DispAll_Valid(:,1:Ino);
        YValid = DatValid.DispAll_Valid(:,Ino+problem.nDOFelim+1:Ino+problem.nDOFelim+Ono);
        problem.YTestTrue = YTest;
        problem.YValidTrue = YValid;
        problem.XScale = 3.2;
        problem.YScale = 1;
        
        XTrain = XTrain./problem.XScale;
        YTrain = YTrain./problem.YScale;
        XTest = XTest./problem.XScale;
        YTest = YTest./problem.YScale;
        XValid = XValid./problem.XScale;
        YValid = YValid./problem.YScale;
        
        [nW, nB, nn] = DNN_Structure(problem.ANNStruc, nn);
        problem.nW = nW;
        problem.nB = nB;
        problem.dim = nW + nB;
%         problem.psY = psY;
        % Separate to training and test data
        I2 = XTrain;
        T = YTrain;
        I2Test = XTest;
        TTest = YTest;
        I2Valid = XValid;
        TValid = YValid;
        
        I2Train = I2;
        TTrain = T;
        problem.xTrain = I2Train';
        problem.yTrain = TTrain';
        
        problem.xTest = I2Test';
        problem.yTest = TTest';
        
        problem.xValid = I2Valid';
        problem.yValid = TValid';
        
        if strcmp(nn.ObjType,'physicLoss')
            problem.fobj = @DPINN_PhysicsLoss_Comb;
        else
            problem.fobj = @DNN_Loss;
        end
        
    case 'EBBeam'
        if strcmp(nn.ObjType,'physicLoss')
        DatTrain = load('.\Training Data\BernBeamSpring_FEINN\Dis_BernBeam1000_Train_50Element.mat');
%         DatTrain = load('.\Training Data\BernBeamSpring_FEINN\Dis_BernBeam1000_Train_50Element_Noise02.mat');
%         DatTrain = load('.\Training Data\BernBeamSpring_FEINN\Dis_BernBeam10000_Train_50Element.mat');
        % DatTrain = load('.\Training Data\BernBeamSpring_FEINN\Dis_BernBeam10000_Train_50Element_Noise02.mat');
% 
%         DatTrain = load('.\Training Data\BernBeamSpring_FEINN\Dis_BernBeam10000_Train_50Element.mat');
        DatTest = load('.\Training Data\BernBeamSpring_FEINN\Dis_BernBeam10000_Test_50Element.mat');
        DatValid = load('.\Training Data\BernBeamSpring_FEINN\Dis_BernBeam_Valid_50Element.mat');
        else
        DatTrain = load('.\Training Data\BernBeamSpring_DDNN\Dis_BernBeam10000_Train_50Element_Noise02.mat');
        DatTest = load('.\Training Data\BernBeamSpring_DDNN\Dis_BernBeam10000_Test_50Element.mat');
        DatValid = load('.\Training Data\BernBeamSpring_DDNN\Dis_BernBeam_Valid_50Element.mat');
        end
        Ino = problem.ANNStruc(1);
%         Ono = problem.ANNStruc(size(problem.ANNStruc,2));
        Ono = problem.OutDat;
        XTrain = DatTrain.DisAllBernBeam_Train(:,1:Ino);
        YTrain = DatTrain.DisAllBernBeam_Train(:,Ino+1:Ino+Ono);
        XTest = DatTest.DisAllBernBeam_Test(:,1:Ino);
        YTest = DatTest.DisAllBernBeam_Test(:,Ino+1:Ino+Ono);
        XValid = DatValid.DisAllBernBeam_Valid(:,1:Ino);
        YValid = DatValid.DisAllBernBeam_Valid(:,Ino+1:Ino+Ono);
        if problem.nDOFelim == 0
            YTrain = YTrain(:,3: Ono-1);
            YTest = YTest(:,3: Ono-1);
        end
        problem.YTestTrue = YTest;
        problem.YValidTrue = YValid;
        problem.XScale = 1000;
        problem.YScale = 100;
        
        XTrain = XTrain./problem.XScale;
        YTrain = YTrain./problem.YScale;
        XTest = XTest./problem.XScale;
        YTest = YTest./problem.YScale;
        XValid = XValid./problem.XScale;
        YValid = YValid./problem.YScale;
        
        [nW, nB, nn] = DNN_Structure(problem.ANNStruc, nn);
        problem.nW = nW;
        problem.nB = nB;
        problem.dim = nW + nB;
%         problem.psY = psY;
        % Separate to training and test data
        I2 = XTrain;
        T = YTrain;
        I2Test = XTest;
        TTest = YTest;
        I2Valid = XValid;
        TValid = YValid;
        
        I2Train = I2;
        TTrain = T;
        problem.xTrain = I2Train';
        problem.yTrain = TTrain';
        
        problem.xTest = I2Test';
        problem.yTest = TTest';
        
        problem.xValid = I2Valid';
        problem.yValid = TValid';
        
        if strcmp(nn.ObjType,'physicLoss')
            problem.fobj = @DPINN_PhysicsLoss_Comb;
        else
            problem.fobj = @DNN_Loss;
        end
        
    case 'CPB'
        if strcmp(nn.ObjType,'physicLoss')
        DatTrain = load('.\Training Data\Plate_FEINN\Dis_Plate10000_Train_Noise02.mat');
        DatTest = load('.\Training Data\Plate_FEINN\Dis_Plate10000_Test.mat');
        DatValid = load('.\Training Data\Plate_FEINN\Dis_Plate_Valid.mat');
        else
        DatTrain = load('.\Training Data\Plate\Dis_Plate10000_Train_Noise02.mat');
        DatTest = load('.\Training Data\Plate\Dis_Plate10000_Test.mat');
        DatValid = load('.\Training Data\Plate\Dis_Plate_Valid.mat');
        end
        
        Ino = problem.ANNStruc(1);
%         Ono = problem.ANNStruc(size(problem.ANNStruc,2));
        Ono = problem.OutDat;
        XTrain = DatTrain.DisAllPlate_Train(1:1000,1:Ino);
        YTrain = DatTrain.DisAllPlate_Train(1:1000,Ino+1:Ino+Ono);
        XTest = DatTest.DisAllPlate_Test(1:1000,1:Ino);
        YTest = DatTest.DisAllPlate_Test(1:1000,Ino+1:Ino+Ono);
        XValid = DatValid.DisAllPlate_Valid(1:200,1:Ino);
        YValid = DatValid.DisAllPlate_Valid(1:200,Ino+1:Ino+Ono);
%         if problem.nDOFelim == 0
%             YTrain = YTrain(:,3: Ono-1);
%             YTest = YTest(:,3: Ono-1);
%         end
        problem.YTestTrue = YTest;
        problem.YValidTrue = YValid;
        problem.XScale = 1;
        problem.YScale = 10;
        
        XTrain = XTrain./problem.XScale;
        YTrain = YTrain./problem.YScale;
        XTest = XTest./problem.XScale;
        YTest = YTest./problem.YScale;
        XValid = XValid./problem.XScale;
        YValid = YValid./problem.YScale;
        
        [nW, nB, nn] = DNN_Structure(problem.ANNStruc, nn);
        problem.nW = nW;
        problem.nB = nB;
        problem.dim = nW + nB;
%         problem.psY = psY;
        % Separate to training and test data
        I2 = XTrain;
        T = YTrain;
        I2Test = XTest;
        TTest = YTest;
        I2Valid = XValid;
        TValid = YValid;
        
        I2Train = I2;
        TTrain = T;
        problem.xTrain = I2Train';
        problem.yTrain = TTrain';
        
        problem.xTest = I2Test';
        problem.yTest = TTest';
        
        problem.xValid = I2Valid';
        problem.yValid = TValid';
        
        if strcmp(nn.ObjType,'physicLoss')
            problem.fobj = @DPINN_PhysicsLoss_Comb;
        else
            problem.fobj = @DNN_Loss;
        end
end
end