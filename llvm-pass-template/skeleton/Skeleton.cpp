#include "llvm/Pass.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

namespace {

struct SkeletonPass : public PassInfoMixin<SkeletonPass> {
  PreservedAnalyses run(Module &M, ModuleAnalysisManager &AM) {
    for (auto &F : M) {
      LLVMContext &Ctx = F.getContext();
      FunctionCallee storeHandler = F.getParent()->getOrInsertFunction(
          "store_handler", Type::getVoidTy(Ctx), Type::getInt32Ty(Ctx));
      FunctionCallee loadHandler = F.getParent()->getOrInsertFunction(
          "load_handler", Type::getVoidTy(Ctx), Type::getInt32Ty(Ctx));
      for (auto &B : F) {
        for (auto &I : B) {
          if (auto *op = dyn_cast<StoreInst>(&I)) {
            errs() << "Store Instruction: " << I << "\n";
            Value *ptr = op->getPointerOperand();
            // If I pass ptr in to CreateCall with storeHandler, I get a varying
            // number. It's the address at which the store instruction value
            // storing a value stored, and it can be dereferenced on the C side.

            Value *val = op->getValueOperand();
            // If I pass in just this, I get the value being stored by a LLVM
            // store instruction
            IRBuilder<> builder(op);

            Value *theString = builder.CreateGlobalStringPtr("hello world\n");
            // if I pass this in, I can read it with signature `char arr[]`

            std::vector<llvm::Value *> args;
            // Multiple arguments need to be passed in to CreateCall as a vector

            args.push_back(ptr);
            // this will be the first argument on the C side

            args.push_back(val);
            // this will be the second argument

            builder.SetInsertPoint(&B, ++builder.GetInsertPoint());
            builder.CreateCall(storeHandler, args);
          }
          if (auto *op = dyn_cast<LoadInst>(&I)) {
            errs() << "Load Instruction: " << I << "\n";
            Value *ptr = op->getPointerOperand();

            IRBuilder<> builder(op);

            std::vector<llvm::Value *> args;

            args.push_back(ptr); 
            // this will be the first argument on the C side
            args.push_back(op); 
            // this will be the second argument

            builder.SetInsertPoint(&B, ++builder.GetInsertPoint());
            builder.CreateCall(loadHandler, args);
          }
        }
      }
    }
    return PreservedAnalyses::all();
  };
};

} // namespace

extern "C" LLVM_ATTRIBUTE_WEAK ::llvm::PassPluginLibraryInfo
llvmGetPassPluginInfo() {
  return {.APIVersion = LLVM_PLUGIN_API_VERSION,
          .PluginName = "Skeleton pass",
          .PluginVersion = "v0.1",
          .RegisterPassBuilderCallbacks = [](PassBuilder &PB) {
            PB.registerPipelineStartEPCallback(
                [](ModulePassManager &MPM, OptimizationLevel Level) {
                  MPM.addPass(SkeletonPass());
                });
          }};
}
