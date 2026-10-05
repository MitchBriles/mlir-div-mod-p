; ModuleID = 'blocksort.ll'
source_filename = "bzip2-1.0.8/blocksort.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@stderr = external global ptr, align 8
@.str.2 = external hidden unnamed_addr constant [28 x i8], align 1
@.str.6 = external hidden unnamed_addr constant [34 x i8], align 1
@.str.7 = external hidden unnamed_addr constant [48 x i8], align 1
@.str.8 = external hidden unnamed_addr constant [44 x i8], align 1

; Function Attrs: noinline nounwind sspstrong uwtable
define hidden void @mainSort(ptr noundef %0, ptr noundef %1, ptr noundef %2, ptr noundef %3, i32 noundef %4, i32 noundef %5, ptr noundef %6) #0 {
  %8 = alloca [256 x i32], align 16
  %9 = alloca [256 x i8], align 16
  %10 = alloca [256 x i32], align 16
  %11 = alloca [256 x i32], align 16
  %12 = icmp sge i32 %5, 4
  br i1 %12, label %13, label %16

13:                                               ; preds = %7
  %14 = load ptr, ptr @stderr, align 8
  %15 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %14, ptr noundef @.str.6) #3
  br label %16

16:                                               ; preds = %13, %7
  br label %17

17:                                               ; preds = %22, %16
  %.013 = phi i32 [ 65536, %16 ], [ %23, %22 ]
  %18 = icmp sge i32 %.013, 0
  br i1 %18, label %19, label %24

19:                                               ; preds = %17
  %20 = sext i32 %.013 to i64
  %21 = getelementptr inbounds i32, ptr %3, i64 %20
  store i32 0, ptr %21, align 4
  br label %22

22:                                               ; preds = %19
  %23 = add nsw i32 %.013, -1
  br label %17, !llvm.loop !5

24:                                               ; preds = %17
  %25 = getelementptr inbounds i8, ptr %1, i64 0
  %26 = load i8, ptr %25, align 1
  %27 = zext i8 %26 to i32
  %28 = shl i32 %27, 8
  %29 = sub nsw i32 %4, 1
  br label %30

30:                                               ; preds = %95, %24
  %.114 = phi i32 [ %29, %24 ], [ %96, %95 ]
  %.08 = phi i32 [ %28, %24 ], [ %90, %95 ]
  %31 = icmp sge i32 %.114, 3
  br i1 %31, label %32, label %97

32:                                               ; preds = %30
  %33 = sext i32 %.114 to i64
  %34 = getelementptr inbounds i16, ptr %2, i64 %33
  store i16 0, ptr %34, align 2
  %35 = ashr i32 %.08, 8
  %36 = sext i32 %.114 to i64
  %37 = getelementptr inbounds i8, ptr %1, i64 %36
  %38 = load i8, ptr %37, align 1
  %39 = zext i8 %38 to i16
  %40 = zext i16 %39 to i32
  %41 = shl i32 %40, 8
  %42 = or i32 %35, %41
  %43 = sext i32 %42 to i64
  %44 = getelementptr inbounds i32, ptr %3, i64 %43
  %45 = load i32, ptr %44, align 4
  %46 = add i32 %45, 1
  store i32 %46, ptr %44, align 4
  %47 = sub nsw i32 %.114, 1
  %48 = sext i32 %47 to i64
  %49 = getelementptr inbounds i16, ptr %2, i64 %48
  store i16 0, ptr %49, align 2
  %50 = ashr i32 %42, 8
  %51 = sub nsw i32 %.114, 1
  %52 = sext i32 %51 to i64
  %53 = getelementptr inbounds i8, ptr %1, i64 %52
  %54 = load i8, ptr %53, align 1
  %55 = zext i8 %54 to i16
  %56 = zext i16 %55 to i32
  %57 = shl i32 %56, 8
  %58 = or i32 %50, %57
  %59 = sext i32 %58 to i64
  %60 = getelementptr inbounds i32, ptr %3, i64 %59
  %61 = load i32, ptr %60, align 4
  %62 = add i32 %61, 1
  store i32 %62, ptr %60, align 4
  %63 = sub nsw i32 %.114, 2
  %64 = sext i32 %63 to i64
  %65 = getelementptr inbounds i16, ptr %2, i64 %64
  store i16 0, ptr %65, align 2
  %66 = ashr i32 %58, 8
  %67 = sub nsw i32 %.114, 2
  %68 = sext i32 %67 to i64
  %69 = getelementptr inbounds i8, ptr %1, i64 %68
  %70 = load i8, ptr %69, align 1
  %71 = zext i8 %70 to i16
  %72 = zext i16 %71 to i32
  %73 = shl i32 %72, 8
  %74 = or i32 %66, %73
  %75 = sext i32 %74 to i64
  %76 = getelementptr inbounds i32, ptr %3, i64 %75
  %77 = load i32, ptr %76, align 4
  %78 = add i32 %77, 1
  store i32 %78, ptr %76, align 4
  %79 = sub nsw i32 %.114, 3
  %80 = sext i32 %79 to i64
  %81 = getelementptr inbounds i16, ptr %2, i64 %80
  store i16 0, ptr %81, align 2
  %82 = ashr i32 %74, 8
  %83 = sub nsw i32 %.114, 3
  %84 = sext i32 %83 to i64
  %85 = getelementptr inbounds i8, ptr %1, i64 %84
  %86 = load i8, ptr %85, align 1
  %87 = zext i8 %86 to i16
  %88 = zext i16 %87 to i32
  %89 = shl i32 %88, 8
  %90 = or i32 %82, %89
  %91 = sext i32 %90 to i64
  %92 = getelementptr inbounds i32, ptr %3, i64 %91
  %93 = load i32, ptr %92, align 4
  %94 = add i32 %93, 1
  store i32 %94, ptr %92, align 4
  br label %95

95:                                               ; preds = %32
  %96 = sub nsw i32 %.114, 4
  br label %30, !llvm.loop !7

97:                                               ; preds = %30
  br label %98

98:                                               ; preds = %115, %97
  %.215 = phi i32 [ %.114, %97 ], [ %116, %115 ]
  %.19 = phi i32 [ %.08, %97 ], [ %110, %115 ]
  %99 = icmp sge i32 %.215, 0
  br i1 %99, label %100, label %117

100:                                              ; preds = %98
  %101 = sext i32 %.215 to i64
  %102 = getelementptr inbounds i16, ptr %2, i64 %101
  store i16 0, ptr %102, align 2
  %103 = ashr i32 %.19, 8
  %104 = sext i32 %.215 to i64
  %105 = getelementptr inbounds i8, ptr %1, i64 %104
  %106 = load i8, ptr %105, align 1
  %107 = zext i8 %106 to i16
  %108 = zext i16 %107 to i32
  %109 = shl i32 %108, 8
  %110 = or i32 %103, %109
  %111 = sext i32 %110 to i64
  %112 = getelementptr inbounds i32, ptr %3, i64 %111
  %113 = load i32, ptr %112, align 4
  %114 = add i32 %113, 1
  store i32 %114, ptr %112, align 4
  br label %115

115:                                              ; preds = %100
  %116 = add nsw i32 %.215, -1
  br label %98, !llvm.loop !8

117:                                              ; preds = %98
  br label %118

118:                                              ; preds = %130, %117
  %.316 = phi i32 [ 0, %117 ], [ %131, %130 ]
  %119 = icmp slt i32 %.316, 34
  br i1 %119, label %120, label %132

120:                                              ; preds = %118
  %121 = sext i32 %.316 to i64
  %122 = getelementptr inbounds i8, ptr %1, i64 %121
  %123 = load i8, ptr %122, align 1
  %124 = add nsw i32 %4, %.316
  %125 = sext i32 %124 to i64
  %126 = getelementptr inbounds i8, ptr %1, i64 %125
  store i8 %123, ptr %126, align 1
  %127 = add nsw i32 %4, %.316
  %128 = sext i32 %127 to i64
  %129 = getelementptr inbounds i16, ptr %2, i64 %128
  store i16 0, ptr %129, align 2
  br label %130

130:                                              ; preds = %120
  %131 = add nsw i32 %.316, 1
  br label %118, !llvm.loop !9

132:                                              ; preds = %118
  %133 = icmp sge i32 %5, 4
  br i1 %133, label %134, label %137

134:                                              ; preds = %132
  %135 = load ptr, ptr @stderr, align 8
  %136 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %135, ptr noundef @.str.2) #3
  br label %137

137:                                              ; preds = %134, %132
  br label %138

138:                                              ; preds = %149, %137
  %.417 = phi i32 [ 1, %137 ], [ %150, %149 ]
  %139 = icmp sle i32 %.417, 65536
  br i1 %139, label %140, label %151

140:                                              ; preds = %138
  %141 = sub nsw i32 %.417, 1
  %142 = sext i32 %141 to i64
  %143 = getelementptr inbounds i32, ptr %3, i64 %142
  %144 = load i32, ptr %143, align 4
  %145 = sext i32 %.417 to i64
  %146 = getelementptr inbounds i32, ptr %3, i64 %145
  %147 = load i32, ptr %146, align 4
  %148 = add i32 %147, %144
  store i32 %148, ptr %146, align 4
  br label %149

149:                                              ; preds = %140
  %150 = add nsw i32 %.417, 1
  br label %138, !llvm.loop !10

151:                                              ; preds = %138
  %152 = getelementptr inbounds i8, ptr %1, i64 0
  %153 = load i8, ptr %152, align 1
  %154 = zext i8 %153 to i32
  %155 = shl i32 %154, 8
  %156 = trunc i32 %155 to i16
  %157 = sub nsw i32 %4, 1
  br label %158

158:                                              ; preds = %235, %151
  %.518 = phi i32 [ %157, %151 ], [ %236, %235 ]
  %.02 = phi i16 [ %156, %151 ], [ %225, %235 ]
  %159 = icmp sge i32 %.518, 3
  br i1 %159, label %160, label %237

160:                                              ; preds = %158
  %161 = zext i16 %.02 to i32
  %162 = ashr i32 %161, 8
  %163 = sext i32 %.518 to i64
  %164 = getelementptr inbounds i8, ptr %1, i64 %163
  %165 = load i8, ptr %164, align 1
  %166 = zext i8 %165 to i32
  %167 = shl i32 %166, 8
  %168 = or i32 %162, %167
  %169 = trunc i32 %168 to i16
  %170 = zext i16 %169 to i64
  %171 = getelementptr inbounds nuw i32, ptr %3, i64 %170
  %172 = load i32, ptr %171, align 4
  %173 = sub i32 %172, 1
  %174 = zext i16 %169 to i64
  %175 = getelementptr inbounds nuw i32, ptr %3, i64 %174
  store i32 %173, ptr %175, align 4
  %176 = sext i32 %173 to i64
  %177 = getelementptr inbounds i32, ptr %0, i64 %176
  store i32 %.518, ptr %177, align 4
  %178 = zext i16 %169 to i32
  %179 = ashr i32 %178, 8
  %180 = sub nsw i32 %.518, 1
  %181 = sext i32 %180 to i64
  %182 = getelementptr inbounds i8, ptr %1, i64 %181
  %183 = load i8, ptr %182, align 1
  %184 = zext i8 %183 to i32
  %185 = shl i32 %184, 8
  %186 = or i32 %179, %185
  %187 = trunc i32 %186 to i16
  %188 = zext i16 %187 to i64
  %189 = getelementptr inbounds nuw i32, ptr %3, i64 %188
  %190 = load i32, ptr %189, align 4
  %191 = sub i32 %190, 1
  %192 = zext i16 %187 to i64
  %193 = getelementptr inbounds nuw i32, ptr %3, i64 %192
  store i32 %191, ptr %193, align 4
  %194 = sub nsw i32 %.518, 1
  %195 = sext i32 %191 to i64
  %196 = getelementptr inbounds i32, ptr %0, i64 %195
  store i32 %194, ptr %196, align 4
  %197 = zext i16 %187 to i32
  %198 = ashr i32 %197, 8
  %199 = sub nsw i32 %.518, 2
  %200 = sext i32 %199 to i64
  %201 = getelementptr inbounds i8, ptr %1, i64 %200
  %202 = load i8, ptr %201, align 1
  %203 = zext i8 %202 to i32
  %204 = shl i32 %203, 8
  %205 = or i32 %198, %204
  %206 = trunc i32 %205 to i16
  %207 = zext i16 %206 to i64
  %208 = getelementptr inbounds nuw i32, ptr %3, i64 %207
  %209 = load i32, ptr %208, align 4
  %210 = sub i32 %209, 1
  %211 = zext i16 %206 to i64
  %212 = getelementptr inbounds nuw i32, ptr %3, i64 %211
  store i32 %210, ptr %212, align 4
  %213 = sub nsw i32 %.518, 2
  %214 = sext i32 %210 to i64
  %215 = getelementptr inbounds i32, ptr %0, i64 %214
  store i32 %213, ptr %215, align 4
  %216 = zext i16 %206 to i32
  %217 = ashr i32 %216, 8
  %218 = sub nsw i32 %.518, 3
  %219 = sext i32 %218 to i64
  %220 = getelementptr inbounds i8, ptr %1, i64 %219
  %221 = load i8, ptr %220, align 1
  %222 = zext i8 %221 to i32
  %223 = shl i32 %222, 8
  %224 = or i32 %217, %223
  %225 = trunc i32 %224 to i16
  %226 = zext i16 %225 to i64
  %227 = getelementptr inbounds nuw i32, ptr %3, i64 %226
  %228 = load i32, ptr %227, align 4
  %229 = sub i32 %228, 1
  %230 = zext i16 %225 to i64
  %231 = getelementptr inbounds nuw i32, ptr %3, i64 %230
  store i32 %229, ptr %231, align 4
  %232 = sub nsw i32 %.518, 3
  %233 = sext i32 %229 to i64
  %234 = getelementptr inbounds i32, ptr %0, i64 %233
  store i32 %232, ptr %234, align 4
  br label %235

235:                                              ; preds = %160
  %236 = sub nsw i32 %.518, 4
  br label %158, !llvm.loop !11

237:                                              ; preds = %158
  br label %238

238:                                              ; preds = %258, %237
  %.619 = phi i32 [ %.518, %237 ], [ %259, %258 ]
  %.13 = phi i16 [ %.02, %237 ], [ %249, %258 ]
  %239 = icmp sge i32 %.619, 0
  br i1 %239, label %240, label %260

240:                                              ; preds = %238
  %241 = zext i16 %.13 to i32
  %242 = ashr i32 %241, 8
  %243 = sext i32 %.619 to i64
  %244 = getelementptr inbounds i8, ptr %1, i64 %243
  %245 = load i8, ptr %244, align 1
  %246 = zext i8 %245 to i32
  %247 = shl i32 %246, 8
  %248 = or i32 %242, %247
  %249 = trunc i32 %248 to i16
  %250 = zext i16 %249 to i64
  %251 = getelementptr inbounds nuw i32, ptr %3, i64 %250
  %252 = load i32, ptr %251, align 4
  %253 = sub i32 %252, 1
  %254 = zext i16 %249 to i64
  %255 = getelementptr inbounds nuw i32, ptr %3, i64 %254
  store i32 %253, ptr %255, align 4
  %256 = sext i32 %253 to i64
  %257 = getelementptr inbounds i32, ptr %0, i64 %256
  store i32 %.619, ptr %257, align 4
  br label %258

258:                                              ; preds = %240
  %259 = add nsw i32 %.619, -1
  br label %238, !llvm.loop !12

260:                                              ; preds = %238
  br label %261

261:                                              ; preds = %268, %260
  %.720 = phi i32 [ 0, %260 ], [ %269, %268 ]
  %262 = icmp sle i32 %.720, 255
  br i1 %262, label %263, label %270

263:                                              ; preds = %261
  %264 = sext i32 %.720 to i64
  %265 = getelementptr inbounds [256 x i8], ptr %9, i64 0, i64 %264
  store i8 0, ptr %265, align 1
  %266 = sext i32 %.720 to i64
  %267 = getelementptr inbounds [256 x i32], ptr %8, i64 0, i64 %266
  store i32 %.720, ptr %267, align 4
  br label %268

268:                                              ; preds = %263
  %269 = add nsw i32 %.720, 1
  br label %261, !llvm.loop !13

270:                                              ; preds = %261
  br label %271

271:                                              ; preds = %274, %270
  %.01 = phi i32 [ 1, %270 ], [ %273, %274 ]
  %272 = mul nsw i32 3, %.01
  %273 = add nsw i32 %272, 1
  br label %274

274:                                              ; preds = %271
  %275 = icmp sle i32 %273, 256
  br i1 %275, label %271, label %276, !llvm.loop !14

276:                                              ; preds = %274
  br label %277

277:                                              ; preds = %334, %276
  %.1 = phi i32 [ %273, %276 ], [ %278, %334 ]
  %278 = sdiv i32 %.1, 3
  br label %279

279:                                              ; preds = %331, %277
  %.821 = phi i32 [ %278, %277 ], [ %332, %331 ]
  %280 = icmp sle i32 %.821, 255
  br i1 %280, label %281, label %333

281:                                              ; preds = %279
  %282 = sext i32 %.821 to i64
  %283 = getelementptr inbounds [256 x i32], ptr %8, i64 0, i64 %282
  %284 = load i32, ptr %283, align 4
  br label %285

285:                                              ; preds = %326, %281
  %.210 = phi i32 [ %.821, %281 ], [ %322, %326 ]
  %286 = sub nsw i32 %.210, %278
  %287 = sext i32 %286 to i64
  %288 = getelementptr inbounds [256 x i32], ptr %8, i64 0, i64 %287
  %289 = load i32, ptr %288, align 4
  %290 = add nsw i32 %289, 1
  %291 = shl i32 %290, 8
  %292 = sext i32 %291 to i64
  %293 = getelementptr inbounds i32, ptr %3, i64 %292
  %294 = load i32, ptr %293, align 4
  %295 = sub nsw i32 %.210, %278
  %296 = sext i32 %295 to i64
  %297 = getelementptr inbounds [256 x i32], ptr %8, i64 0, i64 %296
  %298 = load i32, ptr %297, align 4
  %299 = shl i32 %298, 8
  %300 = sext i32 %299 to i64
  %301 = getelementptr inbounds i32, ptr %3, i64 %300
  %302 = load i32, ptr %301, align 4
  %303 = sub i32 %294, %302
  %304 = add nsw i32 %284, 1
  %305 = shl i32 %304, 8
  %306 = sext i32 %305 to i64
  %307 = getelementptr inbounds i32, ptr %3, i64 %306
  %308 = load i32, ptr %307, align 4
  %309 = shl i32 %284, 8
  %310 = sext i32 %309 to i64
  %311 = getelementptr inbounds i32, ptr %3, i64 %310
  %312 = load i32, ptr %311, align 4
  %313 = sub i32 %308, %312
  %314 = icmp ugt i32 %303, %313
  br i1 %314, label %315, label %327

315:                                              ; preds = %285
  %316 = sub nsw i32 %.210, %278
  %317 = sext i32 %316 to i64
  %318 = getelementptr inbounds [256 x i32], ptr %8, i64 0, i64 %317
  %319 = load i32, ptr %318, align 4
  %320 = sext i32 %.210 to i64
  %321 = getelementptr inbounds [256 x i32], ptr %8, i64 0, i64 %320
  store i32 %319, ptr %321, align 4
  %322 = sub nsw i32 %.210, %278
  %323 = sub nsw i32 %278, 1
  %324 = icmp sle i32 %322, %323
  br i1 %324, label %325, label %326

325:                                              ; preds = %315
  br label %328

326:                                              ; preds = %315
  br label %285, !llvm.loop !15

327:                                              ; preds = %285
  br label %328

328:                                              ; preds = %327, %325
  %.311 = phi i32 [ %322, %325 ], [ %.210, %327 ]
  %329 = sext i32 %.311 to i64
  %330 = getelementptr inbounds [256 x i32], ptr %8, i64 0, i64 %329
  store i32 %284, ptr %330, align 4
  br label %331

331:                                              ; preds = %328
  %332 = add nsw i32 %.821, 1
  br label %279, !llvm.loop !16

333:                                              ; preds = %279
  br label %334

334:                                              ; preds = %333
  %335 = icmp ne i32 %278, 1
  br i1 %335, label %277, label %336, !llvm.loop !17

336:                                              ; preds = %334
  br label %337

337:                                              ; preds = %580, %336
  %.922 = phi i32 [ 0, %336 ], [ %581, %580 ]
  %.04 = phi i32 [ 0, %336 ], [ %.15, %580 ]
  %338 = icmp sle i32 %.922, 255
  br i1 %338, label %339, label %582

339:                                              ; preds = %337
  %340 = sext i32 %.922 to i64
  %341 = getelementptr inbounds [256 x i32], ptr %8, i64 0, i64 %340
  %342 = load i32, ptr %341, align 4
  br label %343

343:                                              ; preds = %389, %339
  %.412 = phi i32 [ 0, %339 ], [ %390, %389 ]
  %.15 = phi i32 [ %.04, %339 ], [ %.2, %389 ]
  %344 = icmp sle i32 %.412, 255
  br i1 %344, label %345, label %391

345:                                              ; preds = %343
  %346 = icmp ne i32 %.412, %342
  br i1 %346, label %347, label %388

347:                                              ; preds = %345
  %348 = shl i32 %342, 8
  %349 = add nsw i32 %348, %.412
  %350 = sext i32 %349 to i64
  %351 = getelementptr inbounds i32, ptr %3, i64 %350
  %352 = load i32, ptr %351, align 4
  %353 = and i32 %352, 2097152
  %354 = icmp ne i32 %353, 0
  br i1 %354, label %383, label %355

355:                                              ; preds = %347
  %356 = sext i32 %349 to i64
  %357 = getelementptr inbounds i32, ptr %3, i64 %356
  %358 = load i32, ptr %357, align 4
  %359 = and i32 %358, -2097153
  %360 = add nsw i32 %349, 1
  %361 = sext i32 %360 to i64
  %362 = getelementptr inbounds i32, ptr %3, i64 %361
  %363 = load i32, ptr %362, align 4
  %364 = and i32 %363, -2097153
  %365 = sub i32 %364, 1
  %366 = icmp sgt i32 %365, %359
  br i1 %366, label %367, label %382

367:                                              ; preds = %355
  %368 = icmp sge i32 %5, 4
  br i1 %368, label %369, label %374

369:                                              ; preds = %367
  %370 = load ptr, ptr @stderr, align 8
  %371 = sub nsw i32 %365, %359
  %372 = add nsw i32 %371, 1
  %373 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %370, ptr noundef @.str.7, i32 noundef %342, i32 noundef %.412, i32 noundef %.15, i32 noundef %372) #3
  br label %374

374:                                              ; preds = %369, %367
  call void @mainQSort3(ptr noundef %0, ptr noundef %1, ptr noundef %2, i32 noundef %4, i32 noundef %359, i32 noundef %365, i32 noundef 2, ptr noundef %6)
  %375 = sub nsw i32 %365, %359
  %376 = add nsw i32 %375, 1
  %377 = add nsw i32 %.15, %376
  %378 = load i32, ptr %6, align 4
  %379 = icmp slt i32 %378, 0
  br i1 %379, label %380, label %381

380:                                              ; preds = %374
  br label %588

381:                                              ; preds = %374
  br label %382

382:                                              ; preds = %381, %355
  %.4 = phi i32 [ %377, %381 ], [ %.15, %355 ]
  br label %383

383:                                              ; preds = %382, %347
  %.3 = phi i32 [ %.15, %347 ], [ %.4, %382 ]
  %384 = sext i32 %349 to i64
  %385 = getelementptr inbounds i32, ptr %3, i64 %384
  %386 = load i32, ptr %385, align 4
  %387 = or i32 %386, 2097152
  store i32 %387, ptr %385, align 4
  br label %388

388:                                              ; preds = %383, %345
  %.2 = phi i32 [ %.3, %383 ], [ %.15, %345 ]
  br label %389

389:                                              ; preds = %388
  %390 = add nsw i32 %.412, 1
  br label %343, !llvm.loop !18

391:                                              ; preds = %343
  %392 = sext i32 %342 to i64
  %393 = getelementptr inbounds [256 x i8], ptr %9, i64 0, i64 %392
  %394 = load i8, ptr %393, align 1
  %395 = icmp ne i8 %394, 0
  br i1 %395, label %396, label %397

396:                                              ; preds = %391
  call void @BZ2_bz__AssertH__fail(i32 noundef 1006)
  br label %397

397:                                              ; preds = %396, %391
  br label %398

398:                                              ; preds = %419, %397
  %.5 = phi i32 [ 0, %397 ], [ %420, %419 ]
  %399 = icmp sle i32 %.5, 255
  br i1 %399, label %400, label %421

400:                                              ; preds = %398
  %401 = shl i32 %.5, 8
  %402 = add nsw i32 %401, %342
  %403 = sext i32 %402 to i64
  %404 = getelementptr inbounds i32, ptr %3, i64 %403
  %405 = load i32, ptr %404, align 4
  %406 = and i32 %405, -2097153
  %407 = sext i32 %.5 to i64
  %408 = getelementptr inbounds [256 x i32], ptr %10, i64 0, i64 %407
  store i32 %406, ptr %408, align 4
  %409 = shl i32 %.5, 8
  %410 = add nsw i32 %409, %342
  %411 = add nsw i32 %410, 1
  %412 = sext i32 %411 to i64
  %413 = getelementptr inbounds i32, ptr %3, i64 %412
  %414 = load i32, ptr %413, align 4
  %415 = and i32 %414, -2097153
  %416 = sub i32 %415, 1
  %417 = sext i32 %.5 to i64
  %418 = getelementptr inbounds [256 x i32], ptr %11, i64 0, i64 %417
  store i32 %416, ptr %418, align 4
  br label %419

419:                                              ; preds = %400
  %420 = add nsw i32 %.5, 1
  br label %398, !llvm.loop !19

421:                                              ; preds = %398
  %422 = shl i32 %342, 8
  %423 = sext i32 %422 to i64
  %424 = getelementptr inbounds i32, ptr %3, i64 %423
  %425 = load i32, ptr %424, align 4
  %426 = and i32 %425, -2097153
  br label %427

427:                                              ; preds = %456, %421
  %.6 = phi i32 [ %426, %421 ], [ %457, %456 ]
  %428 = sext i32 %342 to i64
  %429 = getelementptr inbounds [256 x i32], ptr %10, i64 0, i64 %428
  %430 = load i32, ptr %429, align 4
  %431 = icmp slt i32 %.6, %430
  br i1 %431, label %432, label %458

432:                                              ; preds = %427
  %433 = sext i32 %.6 to i64
  %434 = getelementptr inbounds i32, ptr %0, i64 %433
  %435 = load i32, ptr %434, align 4
  %436 = sub i32 %435, 1
  %437 = icmp slt i32 %436, 0
  br i1 %437, label %438, label %440

438:                                              ; preds = %432
  %439 = add nsw i32 %436, %4
  br label %440

440:                                              ; preds = %438, %432
  %.06 = phi i32 [ %439, %438 ], [ %436, %432 ]
  %441 = sext i32 %.06 to i64
  %442 = getelementptr inbounds i8, ptr %1, i64 %441
  %443 = load i8, ptr %442, align 1
  %444 = zext i8 %443 to i64
  %445 = getelementptr inbounds nuw [256 x i8], ptr %9, i64 0, i64 %444
  %446 = load i8, ptr %445, align 1
  %447 = icmp ne i8 %446, 0
  br i1 %447, label %455, label %448

448:                                              ; preds = %440
  %449 = zext i8 %443 to i64
  %450 = getelementptr inbounds nuw [256 x i32], ptr %10, i64 0, i64 %449
  %451 = load i32, ptr %450, align 4
  %452 = add nsw i32 %451, 1
  store i32 %452, ptr %450, align 4
  %453 = sext i32 %451 to i64
  %454 = getelementptr inbounds i32, ptr %0, i64 %453
  store i32 %.06, ptr %454, align 4
  br label %455

455:                                              ; preds = %448, %440
  br label %456

456:                                              ; preds = %455
  %457 = add nsw i32 %.6, 1
  br label %427, !llvm.loop !20

458:                                              ; preds = %427
  %459 = add nsw i32 %342, 1
  %460 = shl i32 %459, 8
  %461 = sext i32 %460 to i64
  %462 = getelementptr inbounds i32, ptr %3, i64 %461
  %463 = load i32, ptr %462, align 4
  %464 = and i32 %463, -2097153
  %465 = sub i32 %464, 1
  br label %466

466:                                              ; preds = %495, %458
  %.7 = phi i32 [ %465, %458 ], [ %496, %495 ]
  %467 = sext i32 %342 to i64
  %468 = getelementptr inbounds [256 x i32], ptr %11, i64 0, i64 %467
  %469 = load i32, ptr %468, align 4
  %470 = icmp sgt i32 %.7, %469
  br i1 %470, label %471, label %497

471:                                              ; preds = %466
  %472 = sext i32 %.7 to i64
  %473 = getelementptr inbounds i32, ptr %0, i64 %472
  %474 = load i32, ptr %473, align 4
  %475 = sub i32 %474, 1
  %476 = icmp slt i32 %475, 0
  br i1 %476, label %477, label %479

477:                                              ; preds = %471
  %478 = add nsw i32 %475, %4
  br label %479

479:                                              ; preds = %477, %471
  %.17 = phi i32 [ %478, %477 ], [ %475, %471 ]
  %480 = sext i32 %.17 to i64
  %481 = getelementptr inbounds i8, ptr %1, i64 %480
  %482 = load i8, ptr %481, align 1
  %483 = zext i8 %482 to i64
  %484 = getelementptr inbounds nuw [256 x i8], ptr %9, i64 0, i64 %483
  %485 = load i8, ptr %484, align 1
  %486 = icmp ne i8 %485, 0
  br i1 %486, label %494, label %487

487:                                              ; preds = %479
  %488 = zext i8 %482 to i64
  %489 = getelementptr inbounds nuw [256 x i32], ptr %11, i64 0, i64 %488
  %490 = load i32, ptr %489, align 4
  %491 = add nsw i32 %490, -1
  store i32 %491, ptr %489, align 4
  %492 = sext i32 %490 to i64
  %493 = getelementptr inbounds i32, ptr %0, i64 %492
  store i32 %.17, ptr %493, align 4
  br label %494

494:                                              ; preds = %487, %479
  br label %495

495:                                              ; preds = %494
  %496 = add nsw i32 %.7, -1
  br label %466, !llvm.loop !21

497:                                              ; preds = %466
  %498 = sext i32 %342 to i64
  %499 = getelementptr inbounds [256 x i32], ptr %10, i64 0, i64 %498
  %500 = load i32, ptr %499, align 4
  %501 = sub nsw i32 %500, 1
  %502 = sext i32 %342 to i64
  %503 = getelementptr inbounds [256 x i32], ptr %11, i64 0, i64 %502
  %504 = load i32, ptr %503, align 4
  %505 = icmp eq i32 %501, %504
  br i1 %505, label %518, label %506

506:                                              ; preds = %497
  %507 = sext i32 %342 to i64
  %508 = getelementptr inbounds [256 x i32], ptr %10, i64 0, i64 %507
  %509 = load i32, ptr %508, align 4
  %510 = icmp eq i32 %509, 0
  br i1 %510, label %511, label %517

511:                                              ; preds = %506
  %512 = sext i32 %342 to i64
  %513 = getelementptr inbounds [256 x i32], ptr %11, i64 0, i64 %512
  %514 = load i32, ptr %513, align 4
  %515 = sub nsw i32 %4, 1
  %516 = icmp eq i32 %514, %515
  br i1 %516, label %518, label %517

517:                                              ; preds = %511, %506
  call void @BZ2_bz__AssertH__fail(i32 noundef 1007)
  br label %518

518:                                              ; preds = %517, %511, %497
  br label %519

519:                                              ; preds = %528, %518
  %.8 = phi i32 [ 0, %518 ], [ %529, %528 ]
  %520 = icmp sle i32 %.8, 255
  br i1 %520, label %521, label %530

521:                                              ; preds = %519
  %522 = shl i32 %.8, 8
  %523 = add nsw i32 %522, %342
  %524 = sext i32 %523 to i64
  %525 = getelementptr inbounds i32, ptr %3, i64 %524
  %526 = load i32, ptr %525, align 4
  %527 = or i32 %526, 2097152
  store i32 %527, ptr %525, align 4
  br label %528

528:                                              ; preds = %521
  %529 = add nsw i32 %.8, 1
  br label %519, !llvm.loop !22

530:                                              ; preds = %519
  %531 = sext i32 %342 to i64
  %532 = getelementptr inbounds [256 x i8], ptr %9, i64 0, i64 %531
  store i8 1, ptr %532, align 1
  %533 = icmp slt i32 %.922, 255
  br i1 %533, label %534, label %579

534:                                              ; preds = %530
  %535 = shl i32 %342, 8
  %536 = sext i32 %535 to i64
  %537 = getelementptr inbounds i32, ptr %3, i64 %536
  %538 = load i32, ptr %537, align 4
  %539 = and i32 %538, -2097153
  %540 = add nsw i32 %342, 1
  %541 = shl i32 %540, 8
  %542 = sext i32 %541 to i64
  %543 = getelementptr inbounds i32, ptr %3, i64 %542
  %544 = load i32, ptr %543, align 4
  %545 = and i32 %544, -2097153
  %546 = sub i32 %545, %539
  br label %547

547:                                              ; preds = %550, %534
  %.0 = phi i32 [ 0, %534 ], [ %551, %550 ]
  %548 = ashr i32 %546, %.0
  %549 = icmp sgt i32 %548, 65534
  br i1 %549, label %550, label %552

550:                                              ; preds = %547
  %551 = add nsw i32 %.0, 1
  br label %547, !llvm.loop !23

552:                                              ; preds = %547
  %553 = sub nsw i32 %546, 1
  br label %554

554:                                              ; preds = %571, %552
  %.9 = phi i32 [ %553, %552 ], [ %572, %571 ]
  %555 = icmp sge i32 %.9, 0
  br i1 %555, label %556, label %573

556:                                              ; preds = %554
  %557 = add nsw i32 %539, %.9
  %558 = sext i32 %557 to i64
  %559 = getelementptr inbounds i32, ptr %0, i64 %558
  %560 = load i32, ptr %559, align 4
  %561 = ashr i32 %.9, %.0
  %562 = trunc i32 %561 to i16
  %563 = sext i32 %560 to i64
  %564 = getelementptr inbounds i16, ptr %2, i64 %563
  store i16 %562, ptr %564, align 2
  %565 = icmp slt i32 %560, 34
  br i1 %565, label %566, label %570

566:                                              ; preds = %556
  %567 = add nsw i32 %560, %4
  %568 = sext i32 %567 to i64
  %569 = getelementptr inbounds i16, ptr %2, i64 %568
  store i16 %562, ptr %569, align 2
  br label %570

570:                                              ; preds = %566, %556
  br label %571

571:                                              ; preds = %570
  %572 = add nsw i32 %.9, -1
  br label %554, !llvm.loop !24

573:                                              ; preds = %554
  %574 = sub nsw i32 %546, 1
  %575 = ashr i32 %574, %.0
  %576 = icmp sle i32 %575, 65535
  br i1 %576, label %578, label %577

577:                                              ; preds = %573
  call void @BZ2_bz__AssertH__fail(i32 noundef 1002)
  br label %578

578:                                              ; preds = %577, %573
  br label %579

579:                                              ; preds = %578, %530
  br label %580

580:                                              ; preds = %579
  %581 = add nsw i32 %.922, 1
  br label %337, !llvm.loop !25

582:                                              ; preds = %337
  %583 = icmp sge i32 %5, 4
  br i1 %583, label %584, label %588

584:                                              ; preds = %582
  %585 = load ptr, ptr @stderr, align 8
  %586 = sub nsw i32 %4, %.04
  %587 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %585, ptr noundef @.str.8, i32 noundef %4, i32 noundef %.04, i32 noundef %586) #3
  br label %588

588:                                              ; preds = %584, %582, %380
  ret void
}

; Function Attrs: nounwind
declare i32 @fprintf(ptr noundef, ptr noundef, ...) #1

declare void @BZ2_bz__AssertH__fail(i32 noundef) #2

; Function Attrs: noinline nounwind sspstrong uwtable
declare hidden void @mainQSort3(ptr noundef, ptr noundef, ptr noundef, i32 noundef, i32 noundef, i32 noundef, i32 noundef, ptr noundef) #0

attributes #0 = { noinline nounwind sspstrong uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 8, !"PIC Level", i32 2}
!1 = !{i32 7, !"PIE Level", i32 2}
!2 = !{i32 7, !"uwtable", i32 2}
!3 = !{i32 7, !"frame-pointer", i32 2}
!4 = !{!"clang version 23.1.1"}
!5 = distinct !{!5, !6}
!6 = !{!"llvm.loop.mustprogress"}
!7 = distinct !{!7, !6}
!8 = distinct !{!8, !6}
!9 = distinct !{!9, !6}
!10 = distinct !{!10, !6}
!11 = distinct !{!11, !6}
!12 = distinct !{!12, !6}
!13 = distinct !{!13, !6}
!14 = distinct !{!14, !6}
!15 = distinct !{!15, !6}
!16 = distinct !{!16, !6}
!17 = distinct !{!17, !6}
!18 = distinct !{!18, !6}
!19 = distinct !{!19, !6}
!20 = distinct !{!20, !6}
!21 = distinct !{!21, !6}
!22 = distinct !{!22, !6}
!23 = distinct !{!23, !6}
!24 = distinct !{!24, !6}
!25 = distinct !{!25, !6}
